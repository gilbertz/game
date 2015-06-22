require 'grape-swagger'
require 'material/customer_material_api'
require 'material/customer_teamwork_api'
require 'material/customer_headline_api'
require 'banners/customer_banner_api'
# 为c端用户提供的api
module CUSTOMER
  class Root < Grape::API

    prefix 'customer'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    #--------------------helpes-----------------
    helpers do
      def current_user
       p "User.current_user = #{User.current_user.to_json}"
         User.by_openid(request.headers["Wps"])
      end

      def current_material
        p "Material.current_material = #{Material.current_material}"
      #  Material.current_material
      #   Material.find_by_id(1381)
        Material.find_by_url(request.headers["Material_id"])
      end

      def weixin_authorize
        check_cookie
        unless current_user
          redirect_to authorize_url(request.url)
        end
      end

      def check_cookie
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
        #如果没有登录
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
      unauthorized!
    end


    mount CUSTOMER::MaterialInfo::MaterialInfoAPI
    mount CUSTOMER::Teamworks::TeamworkAPI
    mount CUSTOMER::HeadlineInfo::HeadlineAPI
    mount CUSTOMER::Banners::BannerAPI
    #api 文档
    add_swagger_documentation

  end


end
