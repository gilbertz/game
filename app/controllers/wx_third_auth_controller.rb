require 'wx_third/wxsha1'

class WxThirdAuthController < ApplicationController
  skip_before_filter :verify_authenticity_token,only: :componentVerifyTicket
  before_filter :valid_msg_signature,:only => :componentVerifyTicket


  def componentVerifyTicket
    # 微信服务器发送给服务自身的事件推送（如取消授权通知，Ticket推送等）。
    # 此时，消息XML体中没有ToUserName字段，而是AppId字段，
    # 即公众号服务的AppId。
    # 这种系统事件推送通知（现在包括推送component_verify_ticket协议和推送取消授权通知），
    # 服务开发者收到后也需进行解密，接收到后只需直接返回字符串“success”
    wxXMLParams =  params[:xml]
    nowAppId = wxXMLParams[:AppId]
    xmlEncrpyPost = wxXMLParams[:Encrypt]
    # 解密数据
    aes_key   = SHAKE_ENCODKEY
    aes_key   = Base64.decode64("#{aes_key}=")
    hash      = MultiXml.parse(params)['xml']
    body_xml = OpenStruct.new(hash)
    content   = QyWechat::Prpcrypt.decrypt(aes_key, body_xml.Encrypt, SHAKE_APPID)[0]
    # 解密后的数据
    decryptMsg      = MultiXml.parse(content)["xml"]
    Rails.logger.info decryptMsg
    if decryptMsg[:Appid] == SHAKE_APPID
      nowAppId = decryptMsg[:Appid]
      # ticket 事件
      if decryptMsg[:InfoType] == "component_verify_ticket"
        #保存 ticket
        $redis.set(nowappid,ticket);
        # 取消第三方授权事件
      elsif decryptMsg[:InfoType] == "unauthorized"
        # 取消授权的公众账号
        authorizerAppid = decryptMsg[:AuthorizerAppid]

      end
      # 最终返回成功就行
      render :text => "success"
    else
      render :text => "error"
    end
  end


    # before_skip 过滤器  只针对 ticket 取消授权等事件
    private def valid_msg_signature(params)
            timestamp         = params[:timestamp]
            nonce             = params[:nonce]
            encrypt_msg          = params[:Encrypt]
            msg_signature     = params[:msg_signature]
            sort_params       = [SHAKE_TOKEN, timestamp, nonce, encrypt_msg].sort.join
            current_signature = Digest::SHA1.hexdigest(sort_params)
            if current_signature == msg_signature
              return true
            else
              render :text => "error"
              return false
            end
    end
end
