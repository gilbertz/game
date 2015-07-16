module CUSTOMER

  module Banners

    class BannerAPI < Grape::API
      version 'v1'
      #------------------helpers------------------
      helpers do

      end

      #===================get '/banners'=================
      desc '获取banners'
      params do
        optional :state,type:Integer,values: [0, 1],default:1,desc: '是否上线的状态'
      end
      get '/banners',jbuilder:'banners/banner_get' do
        matterial_id = 1112
        state = params["state"]
        @banners = Banner.where(:material_id => matterial_id,:state => state)
      end
      #===================get '/banners'=================


      #===================get '/banners'=================
      desc '随机摇到一个'
      params do
      end
      post '/banners/draw',jbuilder:'banners/banner_draw' do
        matterial_id = 1112
        state = 1
        @banners = Banner.where(:material_id => matterial_id,:state => state)
        if @banners.count > 0
          num = rand @banners.count
          @choice = @banners[num]
        end

      end
      #===================get '/banners'=================




      #===================get '/shakebus'=================
      desc '获取shakebus banners'
      params do
        requires :activity_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        requires :component_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
        optional :state,type:Integer,values: [0, 1],default:1,desc: '是否上线的状态'
      end
      get '/shakebus/:activity_uuid/:component_uuid',jbuilder:'banners/banner_shake_bus' do
        state = params["state"]
        activity = Activity.find_by_uuid(params["activity_uuid"])
        component = Component.find_by_uuid(params["component_uuid"])
        if activity && component
          @bigBanners = Banner.where(:activity_id => activity.id,:state => state,:btype => 1)
          @banners = Banner.where(:activity_id => activity.id,:state => state,:btype => 0)
        end
      end
      #===================get '/shakebus'=================


    end

  end

end
