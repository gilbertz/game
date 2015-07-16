require 'doorkeeper/grape/helpers'
require 'grape-swagger'
require 'material/customer_material_api'
require 'material/customer_teamwork_api'
require 'material/customer_headline_api'
require 'banners/customer_banner_api'
require 'appearance/customer_appearance_api'
# 为c端用户提供的api
module CUSTOMER
  class Root < Grape::API

    prefix 'customer'
    format :json
    #里面有doorkeeper_token 方法
    helpers Doorkeeper::Grape::Helpers
    formatter :json, Grape::Formatter::Jbuilder
    #--------------------helpes-----------------
    helpers do
      def current_user
        u = nil
        du = doorkeeper_user
        if du
          u = du
        else
          t =  request.headers["Wps"]
          u = User.by_openid(t)
        end
        u || test_user
      end

      def doorkeeper_user
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      #  方便测试用
      def test_user
        if  params[:openid]
          User.find_by_id(Authentication.find_by(:uid => params[:openid]).user_id)
        end
      end

      def current_material
        Material.find_by_url(request.headers["Materialid"])
        Material.find_by_id(1381)
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
    mount CUSTOMER::Appearance::AppearanceAPI
    #api 文档
    add_swagger_documentation

  end


end
