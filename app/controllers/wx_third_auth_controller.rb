require 'wx_third/wxsha1'
require 'net/http'
require 'uri'
require 'json'
class WxThirdAuthController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :componentVerifyTicket
  before_filter :valid_msg_signature, :only => :componentVerifyTicket

  # 微信服务器发送给服务自身的事件推送（如取消授权通知，Ticket推送等）。
  # 此时，消息XML体中没有ToUserName字段，而是AppId字段，
  # 即公众号服务的AppId。
  # 这种系统事件推送通知（现在包括推送component_verify_ticket协议和推送取消授权通知），
  # 服务开发者收到后也需进行解密，接收到后只需直接返回字符串“success”
  def componentVerifyTicket
    wxXMLParams = params["xml"]
    nowAppId = wxXMLParams["AppId"]
    # 加密过的数据
    xmlEncrpyPost = wxXMLParams["Encrypt"]
    # 解密数据
    aes_key = SHAKE_ENCODKEY
    aes_key = Base64.decode64("#{aes_key}=")
    content = QyWechat::Prpcrypt.decrypt(aes_key, xmlEncrpyPost, SHAKE_APPID)[0]
    # 解密后的数据
    decryptMsg = MultiXml.parse(content)["xml"]
    if decryptMsg != nil
      nowAppId = decryptMsg["AppId"]
      # ticket 事件
      if decryptMsg["InfoType"] == "component_verify_ticket"
        #保存 ticket
        ticket = decryptMsg["ComponentVerifyTicket"]
        $redis.set(componentVerifyTicketKey(nowAppId), ticket)

        # 取消第三方授权事件
      elsif decryptMsg["InfoType"] == "unauthorized"
        # 取消授权的公众账号
        authorizerAppid = decryptMsg["AuthorizerAppid"]
      end
      # 最终返回成功就行
      render :text => "success"
    else
      render :text => "success"
    end
  end

  #授权登陆发起页面
  def authpage

  end

  # 发起第三方授权登陆 post 请求  成功则直接跳转到微信的
  # 授权登陆页面
  def dothirdauth
    # 获取预授权码  pre_auth_code
    preAuthCode = get_pre_auth_code
    if preAuthCode.nil? == false
      componentloginpageUrl = "https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=#{SHAKE_APPID}&pre_auth_code=#{preAuthCode}"
      #redirectUri = URI.escape("http://j.51self.com/auth/callback")
      redirectUri = "#{SHAKE_DOMAIN}/auth/callback"
      componentloginpageUrl += "&redirect_uri=#{redirectUri}"
      redirect_to componentloginpageUrl
      return
    end
    render :text => "error"
  end

  #发起授权的回调方法
  def callback
    auth_code = params["auth_code"]
    if auth_code.nil? == false
      #查询公众号的授权信息
      auth_info = query_auth_info(auth_code)
      p "auth_info = "+auth_info
    end

  end

  # 接受 授权公众账号的事件、消息等
  def appCallback
    render :text => "success"
  end

  private
  # before_skip 过滤器  只针对 ticket 取消授权等事件
  def valid_msg_signature
    timestamp = params["timestamp"]
    nonce = params["nonce"]
    encrypt_msg = params["xml"]["Encrypt"]
    msg_signature = params["msg_signature"]
    sort_params = [SHAKE_TOKEN, timestamp, nonce, encrypt_msg].sort.join
    current_signature = Digest::SHA1.hexdigest(sort_params)
    if current_signature == msg_signature
      return true
    else
      return false
    end
  end

  # 保存 component_verify_ticket 的key
  def componentVerifyTicketKey(nowAppId)
    nowAppId + "_ComponentVerifyTicket"
  end

  # 保存 component_access_token 的key
  def component_access_token_key(nowAppId)
    nowAppId + "_component_access_token"
  end

  # 保存 get_pre_auth_code 的key
  def pre_auth_code_key(nowAppId)
    nowAppId + "_pre_auth_code"
  end

  # 获取第三方平台令牌（component_access_token）
  def get_component_access_token
    # 如果 redis中存在第三方平台令牌
    componentAccessToken = $redis.get(component_access_token_key(SHAKE_APPID))
    if componentAccessToken.nil? == false && componentAccessToken != ""
      return componentAccessToken
      # 不存在则直接去获取
    else
      # 准备数据
      postData = {"component_appid" => SHAKE_APPID, "component_appsecret" => SHAKE_APPSECRET,
                  "component_verify_ticket" => $redis.get(componentVerifyTicketKey(SHAKE_APPID))}
      res = RestClient::post('https://api.weixin.qq.com/cgi-bin/component/api_component_token', postData.to_json)
      # 解析返回的数据
      retData = JSON.parse(res.body)
      componentAccessToken = retData["component_access_token"]
      expiresIn = retData["expires_in"]
      if componentAccessToken != nil && componentAccessToken != ""
        $redis.set(component_access_token_key(SHAKE_APPID), componentAccessToken)
        $redis.expire(component_access_token_key(SHAKE_APPID), expiresIn)
        return componentAccessToken
      end
    end

    return nil

  end

  # 获取预授权码
  def get_pre_auth_code
    # 如果 redis中存在预授权码
    pre_auth_code = $redis.get(pre_auth_code_key(SHAKE_APPID))
    if pre_auth_code.nil? == false && pre_auth_code != ""
      p "=========从redis中拿"
      return pre_auth_code
      # 不存在则直接去获取
    else
      p "=========从网络中拿"
      #先拿到第三方平台令牌（component_access_token）
      component_access_token = get_component_access_token
      if component_access_token.nil? == false && component_access_token != ""
        postData1 = {"component_appid" => SHAKE_APPID}
        res1 = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{component_access_token}", postData1.to_json)
        retData1 = JSON.parse(res1.body)
        pre_auth_code = retData1["pre_auth_code"]
        preAuthCodeExpiresIn = retData1["expires_in"]
        #保存新的 pre_auth_code
        if pre_auth_code != nil && pre_auth_code != ""
          $redis.set(pre_auth_code_key(SHAKE_APPID), pre_auth_code)
          $redis.expire(pre_auth_code_key(SHAKE_APPID), preAuthCodeExpiresIn)
          return pre_auth_code
        end
      end
    end

    return nil

  end


  #查询公众号的授权信息
  def query_auth_info(auth_code)
    post_data = {"component_appid" => SHAKE_APPID, "authorization_code" => auth_code}
    ret = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token=#{get_component_access_token}", post_data.to_json)
    return JSON.parser(ret.body)
  end

end
