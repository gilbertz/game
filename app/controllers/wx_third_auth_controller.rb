require 'wx_third/wxsha1'
require 'net/http'
require 'uri'
require 'json'
class WxThirdAuthController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :componentVerifyTicket
  before_filter :valid_msg_signature, :only => :componentVerifyTicket


  def componentVerifyTicket
    # 微信服务器发送给服务自身的事件推送（如取消授权通知，Ticket推送等）。
    # 此时，消息XML体中没有ToUserName字段，而是AppId字段，
    # 即公众号服务的AppId。
    # 这种系统事件推送通知（现在包括推送component_verify_ticket协议和推送取消授权通知），
    # 服务开发者收到后也需进行解密，接收到后只需直接返回字符串“success”
    p "???????????????????????????"
    wxXMLParams = params["xml"]
    nowAppId = wxXMLParams["AppId"]
    xmlEncrpyPost = wxXMLParams["Encrypt"]
    # 解密数据
    aes_key = SHAKE_ENCODKEY
    aes_key = Base64.decode64("#{aes_key}=")
    content = QyWechat::Prpcrypt.decrypt(aes_key, xmlEncrpyPost, SHAKE_APPID)[0]
    # 解密后的数据
    decryptMsg = MultiXml.parse(content)["xml"]
    p "========================================"
    p decryptMsg
    Rails.logger.info decryptMsg
    if decryptMsg != nil
      nowAppId = decryptMsg["AppId"]
      # ticket 事件
      if decryptMsg["InfoType"] == "component_verify_ticket"
        p "++++++++++++++++++++++++++++++++++++++"
        #保存 ticket
        ticket = decryptMsg["ComponentVerifyTicket"]
        $redis.set(componentVerifyTicketKey(nowAppId), ticket)
	
	p "ticket is#{$redis.get(componentVerifyTicketKey(nowAppId))}"
        # 取消第三方授权事件
      elsif decryptMsg["InfoType"] == "unauthorized"
        # 取消授权的公众账号
        authorizerAppid = decryptMsg["AuthorizerAppid"]

      end
      # 最终返回成功就行
      render :text => "success"
    else
      p "error=================error=============="
      render :text => "success"
    end
  end


  #授权登陆发起页面
  def authpage
    #render :text =>  "http://www.baidu.com/"
  end

  # 发起第三方授权登陆
  def dothirdauth
    # 获取第三方平台令牌（component_access_token）
    getComponetAccessTokenUrl = URI.parse("https://api.weixin.qq.com/cgi-bin/component/api_component_token")
   # http = Net::HTTP.new(getComponetAccessTokenUrl.host,getComponetAccessTokenUrl.port)
    #http.use_ssl = true if getComponetAccessTokenUrl.scheme == "https"
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
     # http.start{
     #postData = {"component_appid"=>SHAKE_APPID,"component_appsecret"=> SHAKE_APPSECRET,"component_verify_ticket"=> $redis.get(componentVerifyTicketKey(SHAKE_APPID)) }
      #p "postData is #{postData}"

      #res = http.post(getComponetAccessTokenUrl.path,postData)
   # }
      postData = {"appid"=>SHAKE_APPID,"component_appid"=>SHAKE_APPID,"component_AppId"=>SHAKE_APPID,"component_appsecret"=> SHAKE_APPSECRET,"component_verify_ticket"=> "GRebTHtNRkcEA_A2aKwG5_EnBRpRHB5xCADX9PLabM80Aar5V5Zl9wpSjQtIWjNMxEa3zSkF0tU2os_kdFE4NQ" }
    #postData = {:component_appid=>"111"}
    res = RestClient::post('https://api.weixin.qq.com/cgi-bin/component/api_component_token', postData.to_json)
    #res = send_data("https://api.weixin.qq.com/cgi-bin/component/api_component_token",postData.to_json)
    #res =  Net::HTTP.post_form(getComponetAccessTokenUrl,postData)	
    p "===="+res.body
    p "postData is "+postData.to_json
    p SHAKE_APPID
    retData = JSON.parse(res.body)
    p retData
    componentAccessToken = retData["component_access_token"]
    expiresIn = retData["expires_in"]
    p "xxxxxx #{componentAccessToken}"
    p "xxxxxx #{expiresIn}"



    # 获取预授权码  pre_auth_code
    if componentAccessToken.nil? == false
        postData1 = {"component_appid" => SHAKE_APPID}
        res1 = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{componentAccessToken}",postData1.to_json)
        retData1 = JSON.parse(res1.body)
        preAuthCode = retData1["pre_auth_code"]
        preAuthCodeExpiresIn = retData1["expires_in"]

        if preAuthCode.nil? == false
          componentloginpageUrl = "https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=#{SHAKE_APPID}&pre_auth_code=#{preAuthCode}"
          #redirectUri = URI.escape("http://j.51self.com/auth/callback")
          redirectUri = "#{SHAKE_DOMAIN}/auth/callback"
          componentloginpageUrl += "&redirect_uri=#{redirectUri}"
          p "url is" + componentloginpageUrl
          redirect_to componentloginpageUrl
          return
        end


    end


    render :text => "dothirdauth"

  end

  def callback
  end

  def appCallback
  end  

def send_data(url,data)  
    url = URI.parse(url)  
    req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json'})  
    req.body = data  
    res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}  
    return res                                                                                                  
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
      render :text => "error"
      return false
    end
  end

  def componentVerifyTicketKey(nowAppId)
    nowAppId + "_ComponentVerifyTicket"
  end


end
