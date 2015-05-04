require 'digest/md5'
require 'json'
module WxCards

  class CardsClient

    attr_accessor :appid
    # 一个是调用js的 ticket  一个是调用卡券的ticket
    attr_accessor :card_ticket_redis_key,:js_ticket_redis_key

    def initialize(appid)
      @appid = appid
      @card_ticket_redis_key = security_redis_key("api_ticket_#{appid}")
      @js_ticket_redis_key = security_redis_key("js_ticket_#{appid}")
    end


    def api_ticket_store
      ApiTicket::Store.init_with(self)
    end

    def get_card_ticket(access_token)
      api_ticket_store.card_ticket(access_token)
    end

    def get_js_ticket(access_token)
      api_ticket_store.js_ticket(access_token)
    end

    # 获取js sdk 签名包
    def get_js_ticket_sign_package(url)
      timestamp = Time.now.to_i
      noncestr = SecureRandom.hex(16)
      str = "jsapi_ticket=#{get_js_ticket(WxUtil.get_authorizer_access_token(@appid))}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
      signature = Digest::SHA1.hexdigest(str)
      {
          "appId"     => @appid,    "nonceStr"  => noncestr,
          "timestamp" => timestamp, "url"       => url,
          "signature" => signature, "rawString" => str,
      }
    end

    def http_get(url)
      res = RestClient::get(url)
      JSON.parse(res.body)
    end

    def http_post(url,param)
      res = RestClient::post(url, param.to_json)
      JSON.parse(res.body)
    end

    private
    def security_redis_key(key)
      Digest::MD5.hexdigest(key.to_s).upcase
    end


  end


end