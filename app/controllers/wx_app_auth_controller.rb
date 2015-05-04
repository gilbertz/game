require File.expand_path('../wx_third/wx_app_auth',__FILE__)
class WxAppAuthController < ApplicationController

  include WxAppAuth

  def launch
    appid = params["appid"]
    if appid
      redirect_to authurl(appid,"snsapi_userinfo")
    end

  end

  def callback

    p "callback #{params.to_s}"
    code = params["code"]
    state = params["state"]
    # 用户不允许授权 或伪装授权
    if code == nil && state != STATE
      return
    else

    end

  end

end
