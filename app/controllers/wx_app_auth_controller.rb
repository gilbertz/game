require File.expand_path('../wx_third/wx_app_auth',__FILE__)
class WxAppAuthController < ApplicationController

  include WxAppAuth

  def launch
    appid = params["appid"]
    if appid
      redirect_to authurl(appid,"snsapi_userinfo")
      return
    end

    render :text => ""
  end

  def callback

    p "callback #{params.to_s}"
    code = params["code"]
    state = params["state"]
    # 用户不允许授权 或伪装授权
    if code == nil && state != STATE
      return
    else
      appid = params["appid"]
      app_auth_info = get_app_auth_info(appid,code)

      openid = app_auth_info["openid"]
      scope = app_auth_info["scope"]
      # 非静默授权 查询用户的信息保存下来
      if scope == "snsapi_userinfo"
        access_token = app_auth_info["access_token"]
        Thread.new do
          user_info = get_user_info(openid,access_token)
          p "user_info = #{user_info}"
        end
       # 静默授权
      elsif scope == "snsapi_base"


      end

      redirect_to dispatch_url(appid,openid)
      return

    end

    render :text => ""
  end



  def dispatch_url(appid,openid)
    "http://www.baidu.com"

  end

end
