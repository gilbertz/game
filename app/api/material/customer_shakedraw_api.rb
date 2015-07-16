module CUSTOMER

  module  Shakedraw

    class ShakedrawAPI < Grape::API
      version 'v1'
#------------------helpers------------------
      helpers do

      end

      #===================get '/shakedraw/appearance'=================
      desc '获取 shakedraw 数据'
      params do
        requires :activity_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        requires :component_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        optional :state,type:Integer,values: [0, 1],default:1,desc: '是否上线的状态'
      end
      get'/shakedraw/appearance/:activity_uuid/:component_uuid',jbuilder:'material/shakedraw/shakedraw_appearance' do
        state = params["state"]
        activity = Activity.find_by_uuid(params["activity_uuid"])
        component = Component.find_by_uuid(params["component_uuid"])
        if activity && component
          @banners = Banner.where(:activity_id => activity.id,:state => state)
        end
      end
      #===================get '/shakedraw/appearance'=================


      #===================get '/banners'=================
      desc '随机摇到一个'
      params do
        requires :activity_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        requires :component_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
      end
      post '/shakedraw/draw',jbuilder:'banners/banner_draw' do
        matterial_id = 1112
        state = 1
        @banners = Banner.where(:material_id => matterial_id,:state => state)
        if @banners.count > 0
          num = rand @banners.count
          @choice = @banners[num]
        end

      end
      #===================get '/banners'=================


      #===================get '/shakebus/appearance'=================
      desc '获取 shakebus 数据'
      params do
        requires :activity_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        requires :component_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        optional :state,type:Integer,values: [0, 1],default:1,desc: '是否上线的状态'
      end
      get '/shakebus/appearance/:activity_uuid/:component_uuid',jbuilder:'material/shakebus/shakebus_appearance' do
        state = params["state"]
        activity = Activity.find_by_uuid(params["activity_uuid"])
        component = Component.find_by_uuid(params["component_uuid"])
        if activity && component
          @bigBanners = Banner.where(:activity_id => activity.id,:state => state,:btype => 1)
          @banners = Banner.where(:activity_id => activity.id,:state => state,:btype => 0)
        end
      end
      #===================get '/shakebus/appearance'=================






    end
  end
end