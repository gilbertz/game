class WxUtil
  class << self

    # 保存 component_verify_ticket 的key
    def componentVerifyTicketKey(nowAppId)
      nowAppId + "_ComponentVerifyTicket"
    end

    # 保存 component_access_token 的key
    def component_access_token_key(nowAppId)
      nowAppId + "_component_access_token"
    end

    # 保存 get_pre_auth_code 的key
    def pre_auth_code_key(nowAppId)
      nowAppId + "_pre_auth_code"
    end

    #）授权公众号的令牌 key
    def authorizer_access_token_key(authorizer_appid)
      authorizer_appid + "_authorizer_access_token"
    end

    # 获取第三方平台令牌（component_access_token）
    def get_component_access_token
      # 如果 redis中存在第三方平台令牌
      componentAccessToken = $redis.get(component_access_token_key(SHAKE_APPID))
      if componentAccessToken.nil? == false && componentAccessToken != ""
        return componentAccessToken
        # 不存在则直接去获取
      else
        # 准备数据
        postData = {"component_appid" => SHAKE_APPID, "component_appsecret" => SHAKE_APPSECRET,
                    "component_verify_ticket" => $redis.get(componentVerifyTicketKey(SHAKE_APPID))}
        res = RestClient::post('https://api.weixin.qq.com/cgi-bin/component/api_component_token', postData.to_json)
        # 解析返回的数据
        retData = JSON.parse(res.body)
        componentAccessToken = retData["component_access_token"]
        expiresIn = retData["expires_in"]
        p "retData"+retData.to_s
        if componentAccessToken != nil && componentAccessToken != ""
          $redis.set(component_access_token_key(SHAKE_APPID), componentAccessToken)
          $redis.expire(component_access_token_key(SHAKE_APPID), expiresIn.to_i - 60)
          return componentAccessToken
        end
      end

      return nil

    end

    # 获取预授权码
    def get_pre_auth_code
      # 如果 redis中存在预授权码
      pre_auth_code = $redis.get(pre_auth_code_key(SHAKE_APPID))
      p "pre_auth_code is "+pre_auth_code.to_s
      pre_auth_code = nil
      if pre_auth_code.nil? == false && pre_auth_code != ""
        p "=========从redis中拿"
        return pre_auth_code
        # 不存在则直接去获取
      else
        p "=========从网络中拿"
        #先拿到第三方平台令牌（component_access_token）
        component_access_token = get_component_access_token
        if component_access_token.nil? == false && component_access_token != ""
          postData1 = {"component_appid" => SHAKE_APPID}
          res1 = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{component_access_token}", postData1.to_json)
          retData1 = JSON.parse(res1.body)
          p "retData1"+retData1.to_s
          pre_auth_code = retData1["pre_auth_code"]
          preAuthCodeExpiresIn = retData1["expires_in"]
          #保存新的 pre_auth_code
          if pre_auth_code != nil && pre_auth_code != ""
            $redis.set(pre_auth_code_key(SHAKE_APPID), pre_auth_code)
            $redis.expire(pre_auth_code_key(SHAKE_APPID), preAuthCodeExpiresIn.to_i - 60)
            return pre_auth_code
          end
        end
      end

      return nil

    end

    #查询公众号的授权信息
    def query_auth_info(auth_code)
      post_data = {"component_appid" => SHAKE_APPID, "authorization_code" => auth_code}
      ret = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token=#{get_component_access_token}", post_data.to_json)
      return JSON.parse(ret.body)
    end

    #查询已授权公众账号的详细信息
    def get_authorizer_info(authorizer_appid)
      #先拿到第三方平台令牌（component_access_token）
      component_access_token = get_component_access_token
      if component_access_token.nil? == false && component_access_token != ""
        post_data = {"component_appid"=>SHAKE_APPID,"authorizer_appid"=>authorizer_appid}
        res = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token=#{component_access_token}",post_data.to_json)
        authorizer_info = JSON.parse(res.body)
        return authorizer_info
      end

    end

    #获取（刷新）授权公众号的令牌
    def get_authorizer_access_token(authorizer_appid)
      authorizer_access_token = $redis.get(authorizer_access_token_key(authorizer_appid))
      if authorizer_access_token.blank? == false
      #  return authorizer_access_token
      end
      p "get_authorizer_access_token"
      #找到改授权的公众号
      authorizer = WxAuthorizer.find_by_authorizer_appid(authorizer_appid)
      if authorizer.nil?
        return nil
      end
      p "old authorizer_refresh_token = #{authorizer.authorizer_refresh_token}"
      #先拿到第三方平台令牌（component_access_token）
      component_access_token = get_component_access_token
      if component_access_token.nil? == false && component_access_token != ""
        post_data = {"component_appid"=>SHAKE_APPID,"authorizer_appid"=>authorizer_appid,"authorizer_refresh_token" => authorizer.authorizer_refresh_token}
        res = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_authorizer_token?component_access_token=#{component_access_token}",post_data.to_json)
        authorizer_info = JSON.parse(res.body)
        authorizer_access_token = authorizer_info["authorizer_access_token"]
        expires_in = authorizer_info["expires_in"]
        p "new authorizer_refresh_token = #{authorizer_info["authorizer_refresh_token"]}"

        if authorizer_access_token.blank? == false
          $redis.set(authorizer_access_token_key(authorizer_appid),authorizer_access_token)
          $redis.expire(authorizer_access_token_key(authorizer_appid),expires_in.to_i - 60)
          return authorizer_access_token
        end
      end

      return nil
    end



  end
end
