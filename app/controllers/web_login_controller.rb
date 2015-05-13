require File.expand_path('../wx_third/web_login',__FILE__)
require File.expand_path('../wx_third/wx_qrcode',__FILE__)
require File.expand_path('../wx_third/wx_util',__FILE__)
#require File.expand_path('../../workers/authentication_user_work',__FILE__)

class WebLoginController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include WebLogin
  include WxQrcode

  # 传统 微信 web第三方登陆
  def login

    AuthenticationUserWork.perform_async("www","wfww")

    appid = WEB_APPID
    rurl = params["rurl"]
    redirect_to web_auth_url(appid,rurl)

  end

  #扫描二维码登陆
  def qr_login
    p params
    access_token = WxUtil.get_authorizer_access_token("wx456ffb04ee140d84")
    p "access_token = #{access_token}"
    qrcode = generate_qr(access_token)
 #   jsoncallback = params["jsoncallback"]
    render :json =>  {"ticket"=> qrcode.ticket,"qrcode_url"=>qrcode.qrcode_url}.to_json
  end

  def callback
    p "callback #{params.to_s}"
    code = params["code"]
    state = params["state"]
    rurl = params["rurl"]
    # 用户不允许授权 或伪装授权
    if code == nil && state != STATE
    else
      web_auth_info = get_web_auth_info(WEB_APPID,WEB_APPSECRET,code)
      p "web_auth_info #{web_auth_info}"
      if web_auth_info != nil && web_auth_info["errcode"] == nil
        access_token = web_auth_info["access_token"]
        refresh_token = web_auth_info["refresh_token"]
        openid = web_auth_info["openid"]

        user_info = get_user_info(openid,access_token)
        if user_info["errcode"] == nil
          party = Party.find_by_openid(openid)
          unless party
            party = Party.new
          end
          party.openid = openid
          party.refresh_access_token =  refresh_token
          party.access_token = access_token
          party.provide = "weixin"
          party.party_identifier = SecureRandom.uuid
          party.name = user_info["nickname"]
          party.sex = user_info["sex"].to_s
          party.province = user_info["province"]
          party.city = user_info["city"]
          party.country = user_info["country"]
          party.headimgurl = user_info["headimgurl"]
          party.privilege = user_info["privilege"].to_json
          party.unionid = user_info["unionid"]
          flag = party.save
          #  进行登陆


          if flag
            redirect_to rurl
            return
          end

        end

      end

    end

      redirect_to WEB_DOMAIN
  end


end
