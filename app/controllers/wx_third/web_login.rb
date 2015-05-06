module WebLogin

  STATE = "webdapeimishu"

  def web_auth_url(appid,rurl,scope="snsapi_login")
    if rurl.blank?
      rurl = WEB_DOMAIN
    end

    redirect_url = "#{WEB_DOMAIN}/web_login/callback?rurl=#{rurl}"
    url = "https://open.weixin.qq.com/connect/qrconnect?appid=#{appid}&redirect_uri=#{redirect_url}&response_type=code&scope=#{scope}&state=#{STATE}#wechat_redirect"
  end


  #通过code换取access_token 等等信息
  def get_web_auth_info(appid,appsecret,code)
    url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{appid}&secret=#{appsecret}&code=#{code}&grant_type=authorization_code"
    p "get_app_auth_info url is #{url}"
    res = RestClient::get(url)
    ret = JSON.parse(res.body)
  end



  #刷新access_token
  def refresh_web_auth_access_token(appid, refresh_token)
    if appid.nil? || refresh_token.nil?
      return
    else
      url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{appid}&grant_type=refresh_token&refresh_token=#{refresh_token}"
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


  #检验授权凭证（access_token）是否有效
  def is_valid_access_token(openid,access_token)
    if openid.nil? || access_token.nil?
      return false
    end
    url = "https://api.weixin.qq.com/sns/auth?access_token=#{access_token}&openid=#{openid}"
    res = RestClient::get(url)
    ret = JSON.parse(res.body)
    p "is_valid_access_token #{ret.to_s}"
    errcode = ret["errcode"].to_i
    if errcode == 0
      return true
    else
      return false
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

  def web_auth_access_token_key(appid)
    "#{appid}_web_auth_access_token_key"
  end

end