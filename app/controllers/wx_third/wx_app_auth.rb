require File.expand_path('../wx_util',__FILE__)
module WxAppAuth

  STATE = "dapeimishu"

 def authurl(appid,scope="snsapi_base")
   # snsapi_userinfo

   redirect_uri = "#{SHAKE_DOMAIN}/wx_app_auth/callback"
   auth_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{appid}&redirect_uri=#{redirect_uri}&response_type=code&scope=#{scope}&state=#{STATE}&component_appid=#{SHAKE_APPID}#wechat_redirect"
 end


  #通过code换取access_token 等等信息
  def get_app_auth_info(appid,code)
    url = "https://api.weixin.qq.com/sns/oauth2/component/access_token?appid=#{appid}&code=#{code}&grant_type=authorization_code&component_appid=#{SHAKE_APPID}&component_access_token=#{WxUtil.get_component_access_token}"
    p "get_app_auth_info url is #{url}"
    res = RestClient::get(url)
    ret = JSON.parse(res.body)

    p "get_app_auth_info == #{ret.to_s}"
  end



  #刷新access_token
  def refresh_app_auth_access_token(appid, refresh_token)
    if appid.nil? || refresh_token.nil?
      return
    else
      url = "https://api.weixin.qq.com/sns/oauth2/component/refresh_token?appid=#{appid}&grant_type=refresh_token&component_appid=#{SHAKE_APPID}&component_access_token=#{WxUtil.get_component_access_token}&refresh_token=#{refresh_token}"
      res = RestClient::get(url)
      ret = JSON.parse(res.body)
      p "refresh_app_auth_access_token = #{ret.to_s}"

      if ret != nil
        access_token = ret["access_token"]
        expires_in = ret["expires_in"].to_i
        new_refresh_token = ret["refresh_token"]
        openid = ret["openid"]
        scope = ret["scope"]
      end
    end

  end


  #通过网页授权access_token获取用户基本信息（需授权作用域为snsapi_userinfo）
  def get_user_info(openid, access_token)
    if openid.nil? || access_token.nil?
      return nil
    else
      url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
      res = RestClient::get(url)
      ret = JSON.parse(res.body)
    end
  end

  def app_access_token_key(appid)
    "#{appid}_app_access_token_key"
  end

end