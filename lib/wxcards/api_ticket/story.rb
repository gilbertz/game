module WxCards
  module ApiTicket
    class Store
      attr_accessor :cards_client
      def initialize(cards_client)
        @cards_client = cards_client
      end

      def self.init_with(cards_client)
        Store.new(cards_client)
      end

      def api_ticket_expire?
        $redis.hvals(cards_client.api_ticket_redis_key).empty?
      end

      def refresh_api_ticket(access_token)

          set_api_ticket(access_token)
      end

      def api_ticket(access_token)
        refresh_api_ticket(access_token) if api_ticket_expire?
        $redis.get(cards_client.api_ticket_redis_key)
      end

      def set_api_ticket(access_token)
        return_data = cards_client.http_get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token =#{access_token}&type=wx_card")
        return nil if return_data["errcode"].to_i != 0
        ticket = return_data["ticket"]
        expires_in = return_data["expires_in"]
        # 保存到 redis中去
        $redis.set(cards_client.api_ticket_redis_key,ticket)
        $redis.expire(cards_client.api_ticket_redis_key,expires_in.to_i - 60)
      end

    end

  end

end