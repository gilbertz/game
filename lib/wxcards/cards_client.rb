require 'digest/md5'
require 'json'
module WxCards

  class CardsClient

    attr_accessor :appid
    attr_accessor :api_ticket_redis_key

    def initialize(appid)
      @appid = appid
      @api_ticket_redis_key = security_redis_key("api_ticket_#{appid}")
    end


    def api_ticket_store
      ApiTicket::Store.init_with(self)
    end

    def get_api_ticket(access_token)
      api_ticket_store.api_ticket(access_token)
    end

    # 获取js sdk 签名包
    def get_api_ticket_sign_package(url)
      timestamp = Time.now.to_i
      noncestr = SecureRandom.hex(16)
      str = "jsapi_ticket=#{}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
      signature = Digest::SHA1.hexdigest(str)
      {
          "appId"     => app_id,    "nonceStr"  => noncestr,
          "timestamp" => timestamp, "url"       => url,
          "signature" => signature, "rawString" => str
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