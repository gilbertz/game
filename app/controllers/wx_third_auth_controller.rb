require 'wx_third/wxsha1'
require 'net/http'
require 'uri'
require 'json'
require File.expand_path('../wx_third/wx_util',__FILE__)
require File.expand_path('../wx_third/wx_event',__FILE__)
require File.expand_path('../wx_third/wx_message',__FILE__)
class WxThirdAuthController < ApplicationController
  skip_before_filter :verify_authenticity_token#, only: :componentVerifyTicket
  before_filter :valid_msg_signature, :only => :componentVerifyTicket

  # 微信服务器发送给服务自身的事件推送（如取消授权通知，Ticket推送等）。
  # 此时，消息XML体中没有ToUserName字段，而是AppId字段，
  # 即公众号服务的AppId。
  # 这种系统事件推送通知（现在包括推送component_verify_ticket协议和推送取消授权通知），
  # 服务开发者收到后也需进行解密，接收到后只需直接返回字符串“success”
  def componentVerifyTicket
    wxXMLParams = params["xml"]
    nowAppId = wxXMLParams["AppId"]
    # 防止 ticket窜改
    if nowAppId != SHAKE_APPID
      render :text => "success"
      return
    end
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
        $redis.set(WxUtil.componentVerifyTicketKey(nowAppId), ticket)

        # 取消第三方授权事件
      elsif decryptMsg["InfoType"] == "unauthorized"
        # 取消授权的公众账号
        authorizerAppid = decryptMsg["AuthorizerAppid"]
        authorizer = WxAuthorizer.find_by_authorizer_appid(authorizerAppid)
        p authorizer
        if authorizer.nil? == false
          p "update"
          authorizer.unthorized = true
          authorizer.save
          p authorizer
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
    preAuthCode = WxUtil.get_pre_auth_code
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
      auth_info = WxUtil.query_auth_info(auth_code)
      p "auth_info = "+auth_info.to_s
      authorization_info = auth_info["authorization_info"]
      #授权成功
      if authorization_info.blank? == false && authorization_info.has_key?("authorizer_access_token")
        authorizer_appid = authorization_info["authorizer_appid"]
        authorizer_refresh_token = authorization_info["authorizer_refresh_token"]
        expires_in = authorization_info["expires_in"]
        # 获取授权公众账号的信息
        authorizer_info_package = WxUtil.get_authorizer_info(authorizer_appid)
        p "authorizer_info = #{authorizer_info_package.to_s}"
        authorizer = WxAuthorizer.find_by_authorizer_appid(authorizer_appid)
        if authorizer.nil?
          # 创建一个保存
          authorizer = WxAuthorizer.new
        end
        authorizer.authorizer_appid = authorizer_appid
        authorizer.component_appid = SHAKE_APPID
        authorizer.authorization_info = authorization_info.to_json
        authorizer.unthorized = false
        authorizer.authorizer_info = (authorizer_info_package["authorizer_info"]).to_json
        authorizer.authorizer_refresh_token = authorizer_refresh_token
        $redis.set(WxUtil.authorizer_access_token_key(authorizer_appid),authorization_info["authorizer_access_token"])
        $redis.expire(WxUtil.authorizer_access_token_key(authorizer_appid),expires_in.to_i - 60)
        if authorizer_info_package.nil? == false
          authorizer.authorization_info = (authorizer_info_package["authorization_info"]).to_json
          authorizer.qrcode_url = authorizer_info_package["authorizer_info"]["qrcode_url"]
        end
        flag = authorizer.save
        # 处理卡券 及 获取用户列表
        if flag

            p "auth successful!"
	    #WxUtil.save_users(authorizer_appid)
            Thread.new {  deal_card(authorizer_appid)
 			  p "this is new thread!"
            $redis.set("h",1)
           # WxUtil.save_users(authorizer_appid)
            }
            AuthenticationUserWork.perform_async(authorizer_appid,SHAKE_APPID)
        end
        render :json => {"result"=> "success"}.to_json
      end

    else
      render :json => {"result" => "failure"}.to_json
    end

  end

  # 接受 授权公众账号的事件、消息等
  def appCallback
    if valid_msg_signature == false
      p "valid_msg_signature is false"
      render :text => "signature error"
      return
    end
    p "appCallback: appid = #{params["appid"]}"
    wxXMLParams = params["xml"]
    to_appid = params["appid"]
    # 加密过的数据
    xmlEncrpyPost = wxXMLParams["Encrypt"]
    # 解密数据
    aes_key = SHAKE_ENCODKEY
    aes_key = Base64.decode64("#{aes_key}=")
    content = QyWechat::Prpcrypt.decrypt(aes_key, xmlEncrpyPost, SHAKE_APPID)[0]

    authorizer = WxAuthorizer.find_by_authorizer_appid(to_appid)
    p "appCallback: authorizer = " + authorizer.to_s

    # 解密后的数据
    decryptMsg = MultiXml.parse(content)["xml"]
    if decryptMsg.nil? == false
      p "解密后的数据" + decryptMsg.to_s
      deal_msg(to_appid,decryptMsg)
    end
    render :text => "success"
  end


  private

  # 处理消息
  def deal_msg(appid, msg)
    event_type = msg["MsgType"]
    if event_type == "event"
      WxEvent.deal_event_msg(appid,msg)
    elsif event_type == "text"
      WxMessage.deal_text_msg(appid,msg)
    end
  end

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

  def deal_card(authorizer_appid)
   card_id_arr =  WxUtil.query_wx_cards(authorizer_appid)
   p card_id_arr.to_s
   for card_id in card_id_arr
     WxUtil.save_card_info(appid,card_id)
   end

  end

end
