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

      def card_ticket_expire?
        $redis.hvals(cards_client.card_ticket_redis_key).empty?
      end

      def js_ticket_expire?
        $redis.hvals(cards_client.js_ticket_redis_key).empty?
      end

      def refresh_card_ticket(access_token)

          set_card_ticket(access_token)
      end

      def refresh_js_ticket(access_token)

        set_js_ticket(access_token)
      end

      def card_ticket(access_token)
        refresh_card_ticket(access_token) if card_ticket_expire?
        $redis.get(cards_client.card_ticket_redis_key)
      end

      def js_ticket(access_token)
        refresh_js_ticket(access_token) if js_ticket_expire?
        $redis.get(cards_client.js_ticket_redis_key)
      end

      def set_card_ticket(access_token)
        return_data = cards_client.http_get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token =#{access_token}&type=wx_card")
        return nil if return_data["errcode"].to_i != 0
        ticket = return_data["ticket"]
        expires_in = return_data["expires_in"]
        # 保存到 redis中去
        $redis.set(cards_client.card_ticket_redis_key,ticket)
        $redis.expire(cards_client.card_ticket_redis_key,expires_in.to_i - 60)
      end


      def set_js_ticket(access_token)
        return_data = cards_client.http_get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi")
        return nil if return_data["errcode"].to_i != 0
        ticket = return_data["ticket"]
        expires_in = return_data["expires_in"]
        # 保存到 redis中去
        $redis.set(cards_client.js_ticket_redis_key,ticket)
        $redis.expire(cards_client.js_ticket_redis_key,expires_in.to_i - 60)
      end

    end

  end

end