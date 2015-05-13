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
      if componentAccessToken.nil? == false
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
        p "get_component_access_token:retData->"+retData.to_s
        if componentAccessToken != nil
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
      #pre_auth_code = nil
      if pre_auth_code.nil? == false
        p "=========从redis中拿"
        return pre_auth_code
        # 不存在则直接去获取
      else
        p "=========从网络中拿"
        #先拿到第三方平台令牌（component_access_token）
        component_access_token = get_component_access_token
        if component_access_token.nil? == false
          postData1 = {"component_appid" => SHAKE_APPID}
          res1 = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{component_access_token}", postData1.to_json)
          retData1 = JSON.parse(res1.body)
          p "get_pre_auth_code:retData1 -->"+retData1.to_s
          pre_auth_code = retData1["pre_auth_code"]
          preAuthCodeExpiresIn = retData1["expires_in"]

          p "get_pre_auth_code ->pre_auth_code:#{pre_auth_code}  preAuthCodeExpiresIn:#{preAuthCodeExpiresIn}"
          #保存新的 pre_auth_code
          if pre_auth_code != nil
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
      if component_access_token.nil? == false
        post_data = {"component_appid"=>SHAKE_APPID,"authorizer_appid"=>authorizer_appid}
        res = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token=#{component_access_token}",post_data.to_json)
        authorizer_info = JSON.parse(res.body)
        return authorizer_info
      end
      return nil
    end

    #获取（刷新）授权公众号的令牌
    def get_authorizer_access_token(authorizer_appid)
      authorizer_access_token = $redis.get(authorizer_access_token_key(authorizer_appid))
      p "get_authorizer_access_token: authorizer_access_token=#{authorizer_access_token}"
      if authorizer_access_token.nil? == false
      return authorizer_access_token
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
      if component_access_token.nil? == false
        post_data = {"component_appid"=>SHAKE_APPID,"authorizer_appid"=>authorizer_appid,"authorizer_refresh_token" => authorizer.authorizer_refresh_token}
        res = RestClient::post("https://api.weixin.qq.com/cgi-bin/component/api_authorizer_token?component_access_token=#{component_access_token}",post_data.to_json)
        authorizer_info = JSON.parse(res.body)
        authorizer_access_token = authorizer_info["authorizer_access_token"]
        expires_in = authorizer_info["expires_in"]
        p "new authorizer_refresh_token = #{authorizer_info["authorizer_refresh_token"]}"

        p "get_authorizer_access_token:authorizer_access_token=#{authorizer_access_token}  expires_in=#{expires_in}"
        if authorizer_access_token.nil? == false
          $redis.set(authorizer_access_token_key(authorizer_appid),authorizer_access_token)
          $redis.expire(authorizer_access_token_key(authorizer_appid),expires_in.to_i - 60)
          p "redis save authorizer_access_token"
          return authorizer_access_token
        end
      end
      return nil
    end


    #查询授权公众账号的卡券列表
    def query_wx_cards(appid)
      post_data = {"offset"=>0,"count"=>50}
      url = "https://api.weixin.qq.com/card/batchget?access_token=#{get_authorizer_access_token(appid)}"
      res = RestClient::post(url,post_data.to_json)
      info = JSON.parse(res.body)
      if info["errcode"].to_i == 0
        return info["card_id_list"]
      end
      return Array.new
    end

    #查询卡券详情
    def query_card_detail(appid, card_id)
      post_data = {"card_id"=>card_id}
      url = "https://api.weixin.qq.com/card/get?access_token=#{get_authorizer_access_token(appid)}"
      res = RestClient::post(url,post_data.to_json)
      info = JSON.parse(res.body)
      if info["errcode"].to_i == 0
        return info["card"]
      end
      return nil
    end

    #调用查询 code 接口可获取 code 的有效性(非自定义 code)
    # 该 code 对应的用户 openid、卡券有效期等信息。
    #自定义 code(use_custom_code 为 true)的卡券调用接口时
    # post 数据中需包含 card_id,非自定义 code 不需上报。
    def query_code_info(appid, code)
      post_data = {"code"=>code}
      url = "https://api.weixin.qq.com/card/code/get?access_token=#{get_authorizer_access_token(appid)}"
      res = RestClient::post(url,post_data.to_json)
      info = JSON.parse(res.body)
      if info["errcode"].to_i == 0
        return info
      end
    end

    # 根据card_id保存 卡券信息
    def save_card_info(appid,card_id)
      card_info = query_card_detail(authorizer_appid,card_id)
      if card_info
        p "card_info : #{card_info.to_s}"
        card = Card.find_by_cardid(card_id)
        if card.nil?
          card = Card.new
        end
        card.cardid = card_id
        card.wx_authorizer_id = authorizer_appid
        card.appid = authorizer_appid

        detail_info =  card_info["card_info"]
        card.detail_info = detail_info.to_json
        card_type = detail_info["card_type"]
        card.card_type = card_type

        base_info = detail_info[card_type.downcase]["base_info"]
        card.code_type = base_info["code_type"]
        card.title = base_info["title"]
        card.sub_title = base_info["sub_title"]
        card.desc = base_info["description"]
        card.status = base_info["status"]
        card.store = base_info["sku"]["quantity"]
        card.total_quantity =  base_info["sku"]["total_quantity"]
        card.save
      end

    end


    # 保存卡券纪录
    def save_card_record(appid,event_msg)
      if event_msg.nil?
        return
      end
      card_id = event_msg["CardId"]
      card_recode = CardRecord.new
      card_recode.appid = appid
      card_recode.card_id = card_id
      card_recode.event = event_msg["Event"]
      card_recode.is_give_by_friend = event_msg["IsGiveByFriend"]
      card_recode.user_card_code = event_msg["UserCardCode"]
      card_recode.outer_id = event_msg["OuterId"]
      card_recode.old_user_card_code = event_msg["OldUserCardCode"]
      card_recode.event_time = Time.at((event_msg["CreateTime"]).to_i)
      card_recode.save

      p "card_recode = #{card_recode.to_s}"
    end

    #获取某个公众账号的用户列表信息
    def get_user_openid_list(appid,openid_list,next_openid)
      if openid_list
        openid_list = []
      end
      url = "https://api.weixin.qq.com/cgi-bin/user/get?access_token=#{get_authorizer_access_token(appid)}&next_openid=#{next_openid}"
      res = RestClient::get(url)
      info = JSON.parse(res.body)
      p "get_user_openid_list  #{info}"
      if info == nil || info["total"] == nil || info["total"].to_i <= 0
        return
      else
        if info["total"].to_i <  10000
        openid_list << info["data"]["openid"]
        return
        else
          now_next_openid = info["next_openid"]
          get_user_openid_list(appid,openid_list,now_next_openid)
        end
      end
    end

    def save_users(appid)
      openid_list = []
      get_user_openid_list(appid,openid_list,nil)
      p "openid_list = #{openid_list}"
      openid_list.each do |p|
        authentication = Authentication.find_by_uid(p)
        if authentication
          authentication.isfollow = "1"
          authentication.save
        else
          info = user_info(get_authorizer_access_token(appid),p)
          save_user(appid,info)
        end

      end

    end



    def user_info(access_token,openid)
      if access_token == nil || openid == nil
        return
      end
      url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
      res = RestClient::get(url)
      JSON.prase(res.body)
    end

    def save_user(appid,user_info)
      if user_info == nil || user_info["openid"] == nil
        return
      end
      authentication = Authentication.find_by_uid(user_info["openid"])
      unless authentication
        #创建一个user
        user = User.new
        user.name = user_info["nickname"]
        user.email = "fk"+Devise.friendly_token[0,20]+"@yaoshengyi.com"
        user.password = Devise.friendly_token[0,12]
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
      authentication.unionid = user_info["unionid"]
      authentication.provider = "weixin"
      authentication.sex = user_info["sex"].to_s
      authentication.city = user_info["city"]
      authentication.province = user_info["province"]
      authentication.isfollow = "1"
      authentication.groupid = user_info["groupid"]
      authentication.save
    end


  end
end
