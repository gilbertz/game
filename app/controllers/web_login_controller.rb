require File.expand_path('../wx_third/web_login',__FILE__)

class WebLoginController < ApplicationController
  include WebLogin

  def login
    appid = WEB_APPID
    rurl = params["rurl"]
    redirect_to web_auth_url(appid,rurl)
  end


  def callback

    p "callback #{params.to_s}"
    code = params["code"]
    state = params["state"]
    # 用户不允许授权 或伪装授权
    if code == nil && state != STATE
      redirect_to WEB_DOMAIN
    else

    end

  end


end
