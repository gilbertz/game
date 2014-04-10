# locate the class in lib/qq/command/client.rb
module Qzone::Command
  class Client
    include Qzone::Command::Ext::Config
    include Qzone::Command::Ext::Parameters

    def initialize(attributes = {})
      attributes.each_pair do |name, value|
        send("#{name}=", value)
      end
    end

    def attributes
      @attributes ||= {}
    end

    def request_params
      params_after_sign
    end

    def base_url
      "http://#{host}#{path}"
    end

    def request_url
      if http_method.upcase == 'GET'
        base_url + '?' + request_params.to_query
      else
        base_url
      end
    end

    def fetch
      conn = Faraday.new  do |faraday|
        faraday.adapter :em_http # make requests with Net::HTTP
        faraday.response :logger if Rails.env.development?
      end

      response = if http_method.upcase == 'GET'
                   conn.get(request_url)
                 else
                   conn.post request_url, request_params
                 end
      ActiveSupport::JSON.decode response.body
    end
  end
end