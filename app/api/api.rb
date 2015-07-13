require 'doorkeeper/grape/helpers'
require 'grape-swagger'
require 'image/image_api'
require 'redpack/redpack_api'
require 'cards/card_api'
require 'pay/pay_api'
require 'orders/order_api'
require 'behaviour/behaviour_api'
require 'activity_check/activity_check_api'
require 'merchant_info/merchant_info_api'
require 'merchant_info/party_info_api'
require 'statis/statis_api'

module API
  #一个服务一个模块  小型微服务
  class Root < Grape::API
    prefix 'api'
    format :json
    #use ::WineBouncer::OAuth2
     formatter :json, Grape::Formatter::Jbuilder 
     helpers Doorkeeper::Grape::Helpers
    #--------------------helpes-----------------
    helpers do
      def current_party
        if current_user
          current_user.party
        end
      end

      def current_user
        p "resource_owner"
       # p resource_owner
        p "test_user"
        p test_user
        p "doorkeeper_user"
        p doorkeeper_user
       test_user || doorkeeper_user
      end
      
       def doorkeeper_user
         #User.find(doorkeeper_access_token.resource_owner_id) if doorkeeper_access_token
         User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
        end

      #  方便测试用
      def test_user
        if  params[:openid]
          User.find_by_id(Authentication.find_by(:uid => params[:openid]).user_id)
        end
      end

      def current_party_id
	      current_party.id
      end

      def weixin_authorize
        check_cookie
        unless current_user
          redirect_to authorize_url(request.url)
        end
      end

      def check_cookie
        if true
          unless current_user
            if cookies.signed[:remember_me].present?
              user = User.find_by_rememberme_token cookies.signed[:remember_me]
              if user && user.rememberme_token == cookies.signed[:remember_me]
                session[:admin_user_id] = user.id
                current_user = user
                User.current_user = current_user
              end
            end
          end
        end
      end

      def authorize_url(url)
        appid = WX_APPID
        if params[:y1y_beacon_url]
          get_beacon
          appid = @beacon.get_merchant.wxappid
        end
        "http://#{WX_DOMAIN}/#{appid}/launch?rurl=" + url
      end

      def user_agent!
        ua = request.user_agent.downcase
        unless ua.index("micromessenger")
          error_403!
        end
      end

      def request_headers!
        unless request.headers['Secret'] == "yaoshengyi"
          error_403!
        end
      end

      def unauthorized!
        #如果没有登录x
        unless current_user
          render_api_error! '401 Unauthorized', 401
        end
      end

      def not_allowed!
        render_api_error! 'Method Not Allowed', 405
      end

      def internal_error!
        render_api_error! 'Internal Server Error', 500
      end

      def render_api_error!(message, status = 405)
        h = Hash.new
        h["result"] = -1
        h["error"] = message if message
        error! h, status
      end

      def error_403!
        error! 'Forbidden', 403
      end
    end
    # ---------------before-------------
    before do
     p "xddd"
    p doorkeeper_token
      unauthorized!
     #auth: { scopes: [] }
 #    p "doorkeeper_access_token "
  #   p doorkeeper_access_token
      #p "=====xxx  #{doorkeeper_authorize!}"
     #oauth2 'public'
    end
    mount API::PartyInfo::PartyInfoAPI
    mount API::MerchantInfo::MerchantInfoAPI
    mount API::Pay::PayAPI
    mount API::Orders::OrderAPI
    mount API::Image::ImageAPI
    mount API::ActivityCheck::ActivityCheckAPI
    mount API::RedPack::RedpackAPI
    mount API::Cards::CardAPI
    mount API::Behaviour::BehaviourAPI
    mount API::Statis::StatisAPI

    #api 文档
    add_swagger_documentation
  end
end
