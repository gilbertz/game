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
        authorizer = WxAuthorizer.find_by_authorizer_appid(authorizerAppid)
        if authorizer.nil? == false
          authorizer.unthorized == true
          authorizer.update
        end
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
      p "auth_info = "+auth_info.to_s
      authorization_info = auth_info["authorization_info"]
      #授权成功
      if authorization_info.blank? == false && authorization_info.has_key?("authorizer_access_token")
        authorizer_appid = authorization_info["authorizer_appid"]
        authorizer_refresh_token = authorization_info["authorizer_refresh_token"]
        expires_in = authorization_info["expires_in"]
        # 获取授权公众账号的信息
        authorizer_info = get_authorizer_info(authorizer_appid)
        p "authorizer_info = #{authorizer_info.to_s}"
        authorizer = WxAuthorizer.find_by_authorizer_appid(authorizer_appid)
        if authorizer.blank?
          # 创建一个保存
          authorizer = WxAuthorizer.new
        end
        authorizer.authorizer_appid = authorizer_appid
        authorizer.component_appid = SHAKE_APPID
        authorizer.authorization_info = authorization_info
        authorizer.unthorized = false
        authorizer.authorizer_info = authorizer_info["authorizer_info"]
        authorizer.authorizer_refresh_token = authorizer_refresh_token
        $redis.set(authorizer_access_token_key(authorizer_appid),authorization_info["authorizer_access_token"])
        $redis.expire(authorizer_access_token_key(authorizer_appid),expires_in.to_i - 60)
        if authorizer_info.blank? == false
          authorizer.qrcode_url = authorizer_info["qrcode_url"]
        end
        authorizer.save
        render :json => {"result"=> 0}.to_json
      end

    else
      render :json => {"result" => 1}.to_json
    end

  end

  # 接受 授权公众账号的事件、消息等
  def appCallback
    if valid_msg_signature == false
      render :text => "signature error"
      return
    end
    p params["appid"]
    wxXMLParams = params["xml"]
    to_appid = wxXMLParams["appid"]
    # 加密过的数据
    xmlEncrpyPost = wxXMLParams["Encrypt"]
    # 解密数据
    aes_key = SHAKE_ENCODKEY
    aes_key = Base64.decode64("#{aes_key}=")
    content = QyWechat::Prpcrypt.decrypt(aes_key, xmlEncrpyPost, SHAKE_APPID)[0]

    authorizer = WxAuthorizer.find_by_authorizer_appid(to_appid)
    p "authorizer = " + authorizer.to_s
    # 发送消息

    # 解密后的数据
    decryptMsg = MultiXml.parse(content)["xml"]
    if decryptMsg.nil? == false
      p "解密后的数据" + decryptMsg.to_s
      deal_msg(to_appid,decryptMsg)
    end

    render :text => ""
  end

  # 处理消息
  def deal_msg(appid, msg)
    event_type = msg["MsgType"]
    if event_type == "event"
      deal_event_msg(appid,msg)
    elsif event_type == "text"
      deal_text_msg(appid,msg)
    end
  end

  # 处理第三方的文本消息
  def deal_text_msg(appid,text_msg)
    # 发送给某个公众账号的---微信号
    to_user_name = event_msg["ToUserName"]
    # 普通微信用户的open id
    from_user_name = event_msg["FromUserName"]
  end

  # 处理第三放的事件消息
  def deal_event_msg(appid,event_msg)
    # 发送给某个公众账号的---微信号
    to_user_name = event_msg["ToUserName"]
    # 普通微信用户的open id
    from_user_name = event_msg["FromUserName"]
    

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

  #）授权公众号的令牌 key
  def authorizer_access_token_key(authorizer_appid)
    authorizer_appid + "_authorizer_access_token"
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
      p "retData"+retData.to_s
      if componentAccessToken != nil && componentAccessToken != ""
        $redis.set(component_access_token_key(SHAKE_APPID), componentAccessToken)
        $redis.expire(component_access_token_key(SHAKE_APPID), expiresIn.to_i - 60)
        return componentAccessToken
      end
    end

    return nil

  end

  # 获取预授权码
  def get_pre_auth_code
    # 如果 redis中存在预授权码
    pre_auth_code = $redis.get(pre_auth_code_key(SHAKE_APPID))
    p "pre_auth_code is "+pre_auth_code.to_s
    pre_auth_code = nil
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
        p "retData1"+retData1.to_s
        pre_auth_code = retData1["pre_auth_code"]
        preAuthCodeExpiresIn = retData1["expires_in"]
        #保存新的 pre_auth_code
        if pre_auth_code != nil && pre_auth_code != ""
          $redis.set(pre_auth_code_key(SHAKE_APPID), pre_auth_code)
          $redis.expire(pre_auth_code_key(SHAKE_APPID), preAuthCodeExpiresIn.to_i - 60)
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
    return JSON.parse(ret.body)
  end

  #查询已授权公众账号的详细信息
  def get_authorizer_info(authorizer_appid)
    #先拿到第三方平台令牌（component_access_token）
    component_access_token = get_component_access_token
    if component_access_token.nil? == false && component_access_token != ""
      post_data = {"component_appid"=>SHAKE_APPID,"authorizer_appid"=>authorizer_appid}
      res = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token=#{component_access_token}",post_data.to_json)
      authorizer_info = JSON.parse(res.body)
      return authorizer_info
    end

  end
  
  #获取（刷新）授权公众号的令牌
  def get_authorizer_access_token(authorizer_appid)
    authorizer_access_token = $redis.get(authorizer_access_token_key(authorizer_appid))
    if authorizer_access_token.blank? == false
      return authorizer_access_token
    end
    #找到改授权的公众号
    authorizer = WxAuthorizer.find_by_sql("select * from wx_authorizers where authorizer_id=#{authorizer_appid}")
    if authorizer_id.nil?
      return nil
    end
    p "old authorizer_refresh_token = #{authorizer.authorizer_refresh_token}"
    #先拿到第三方平台令牌（component_access_token）
    component_access_token = get_component_access_token
    if component_access_token.nil? == false && component_access_token != ""
      post_data = {"component_appid"=>SHAKE_APPID,"authorizer_appid"=>authorizer_appid,"authorizer_refresh_token" => authorizer.authorizer_refresh_token}
      res = RestClient::post("https:// api.weixin.qq.com /cgi-bin/component/api_authorizer_token?component_access_token=#{component_access_token}",post_data.to_json)
      authorizer_info = JSON.parse(res.body)
      authorizer_access_token = authorizer_info["authorizer_access_token"]
      expires_in = authorizer_info["expires_in"]
      p "new authorizer_refresh_token = #{authorizer_info["authorizer_refresh_token"]}"

      if authorizer_access_token.blank? == false
        $redis.set(authorizer_access_token_key(authorizer_appid),authorizer_access_token)
        $redis.expire(authorizer_access_token(authorizer_appid),expires_in.to_i - 60)
        return authorizer_access_token
      end
    end

    return nil
  end





end
