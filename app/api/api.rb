require 'grape-swagger'
require 'redpack/redpack_api'
require 'cards/card_api'
require 'pay/pay_api'
require 'orders/order_api'
require 'behaviour/behaviour_api'
require 'behaviour/check_api'
require 'merchant_info/merchant_info_api'
require 'merchant_info/party_info_api'
module API
  #一个服务一个模块  小型微服务
  class Root < Grape::API
    prefix 'api'
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do

      def current_user
        User.current_user
      end

      def unauthorized!
        #如果没有登录x
        unless current_user
          render_api_error! '401 Unauthorized',401
        end
      end

      def not_allowed!
        render_api_error! 'Method Not Allowed',405
      end

      def internal_error!
        render_api_error! 'Internal Server Error',500
      end

      def render_api_error!(message,status = 405)
        h = Hash.new
        h["result"] = -1
        h["error"] = message if message
        error! message,status
      end
      def error_403!
        error! 'Forbidden',403
      end
    end

    before do
      # unauthorized!
    end



    mount API::RedPack::RedpackAPI
    mount API::Cards::CardAPI
    mount API::Orders::OrderAPI
    mount API::Pay::PayAPI
    mount API::Behaviour::BehaviourAPI
    mount API::MerchantInfo::MerchantInfoAPI
    mount API::PartyInfo::PartyInfoAPI
    mount API::Behaviour::CheckAPI

    #api 文档
    add_swagger_documentation
  end


end
