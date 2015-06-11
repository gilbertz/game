require 'grape-swagger'
require 'cards/normal_card_api'
require 'statis/statis_api'
# 不需要验证的api
module NORMAL
  class Root < Grape::API
    prefix 'normal'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    #--------------------helpes-----------------
    helpers do
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

    end

    mount NORMAL::Cards::CardAPI
    mount API::Statis::StatisAPI
    #api 文档
    add_swagger_documentation

  end



end