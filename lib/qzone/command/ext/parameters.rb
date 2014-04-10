# locate the class in lib/qq/command/ext/parameters.rb
module Qzone::Command::Ext
  module Parameters

    extend ActiveSupport::Concern

    included do
      attr_accessor :openid, :openkey, :pf, :path
      attr_writer :params, :http_method
    end

    def default_params
      {
          openid: openid,
          openkey: openkey,
          appid: appid,
          pf: pf,
          format: format
      }
    end

    def params_before_sign
      parameters = default_params.merge(params)
      parameters.delete_if {|name, value| value.nil?}
      parameters
    end

    def params
      @params ||= {}
    end

    def params_after_sign
      encoded_uri = URI.encode(path)

      params_before_sign.merge(:sig => self.class.sign(path, http_method, params_before_sign))
    end

    def format
      @format ||= 'json'
    end

    def http_method
      @http_method ||= 'GET'
    end

    module ClassMethods
      def sign(path, http_method, options = {})
        encoded_uri = CGI.escape(path)

        params_str = options.keys.sort.map do |name|
          "#{name}=#{options[name]}"
        end.join('&')

        encoded_str = CGI.escape(params_str)

        text = [http_method.upcase, encoded_uri, encoded_str].join('&')

        secret = "#{appkey}&"

        require 'openssl' unless defined?(OpenSSL)

        Base64.strict_encode64 OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, secret, text)
      end
    end
  end
end