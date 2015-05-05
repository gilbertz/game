require File.expand_path('../wx_third/wx_app_auth',__FILE__)
class WxAppAuthController < ApplicationController

  include WxAppAuth

  def launch
    appid = params["appid"]
    if appid
      redirect_to authurl(appid)
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
      p app_auth_info
      openid = app_auth_info["openid"]
      scope = app_auth_info["scope"]
      p scope
      p "openid = #{openid}"
      # 非静默授权 查询用户的信息保存下来
      if scope == "snsapi_userinfo"
        access_token = app_auth_info["access_token"]
        Thread.new do
         p "*******************************"
          user_info = get_user_info(openid,access_token)
          p "user_info = #{user_info}"
         authentication = Authentication.find_by_uid(openid)
         if authentication == nil
            #创建一个user
           user = User.new
           user.name = user_info["nickname"]
           user.sex = user_info["sex"].to_i
           user.city = user_info["city"]
           user.country = user_info["country"]
           user.province = user_info["province"]
           user.profile_img_url = user_info["headimgurl"]
           user.save
          authentication = Authentication.new
         end
         authentication.user_id = user.id
         authentication.uid = user_info["openid"]
         authentication.appid = appid
         authentication.access_token = access_token
         authentication.unionid = user_info["unionid"]
         authentication.provider = "weixin"
         authentication.sex = user_info["sex"].to_s
         authentication.city = user_info["city"]
         authentication.province = user_info["province"]
         authentication.expires_at = Time.now.to_i + app_auth_info["expires_in"].to_i - 100
         authentication.save

          p "authentication = #{authentication}"
        end
       # 静默授权
      elsif scope == "snsapi_base"
        #通过openid 在本地找用户 没有找到则启动非静默授权
        authentication = Authentication.find_by_uid(openid)
        if authentication
          p "找到了======"
        else
          p "没有找到  开启授权"
          redirect_to authurl(appid,"snsapi_userinfo")
          return
        end
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
