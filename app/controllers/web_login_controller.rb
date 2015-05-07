require File.expand_path('../wx_third/web_login',__FILE__)
require File.expand_path('../wx_third/wx_qrcode',__FILE__)
require File.expand_path('../wx_third/wx_util',__FILE__)


class WebLoginController < ApplicationController
  include WebLogin
  include WxQrcode

  def login
    # appid = WEB_APPID
    # rurl = params["rurl"]
    # redirect_to web_auth_url(appid,rurl)



    # access_token = WxUtil.get_authorizer_access_token("wx456ffb04ee140d84")
    # p "access_token = #{access_token}"
    # redirect_to generate_qr(access_token)

    $wxclient.send_text_custom("oNnqbt3JTnBKj1E6uwbD3jfGc_tY","1245")
    $wxclient.send_template_msg("oNnqbt3JTnBKj1E6uwbD3jfGc_tY", "1-DZpzUOCJ-Es-QLgSS0mu83fZ-O9w6iWm0hZKSq8G8", "http://www.dapeimishu.com/", "#FF0000",  "data"=>{
        "first"=> {
        "value"=>"恭喜你购买成功！",
        "color"=>"#173177"
    }})


    redirect_to "http://www.dapeimishu.com/"
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
