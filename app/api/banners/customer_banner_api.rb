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
        requires :activity_uuid, type: String, allow_blank: false, desc: "活动唯一标识."
        optional :state,type:Integer,values: [0, 1],default:1,desc: '是否上线的状态'
      end
      get '/banners',jbuilder:'banners/banner_get' do
        state = params["state"]
        activity = Activity.find_by_uuid(params["activity_uuid"])
        if activity
          @bigBanners = Banner.where(:activity_id => activity.id,:state => state,:btype => 1)
          @banners = Banner.where(:activity_id => activity.id,:state => state,:btype => 0)
        end
      end
      #===================get '/banners'=================



      # ===================post '/banners/draw'=================
      desc '随机摇到一个'
      params do
        requires :activity_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
      end
      post '/banners/draw',jbuilder:'banners/banner_draw' do
        activity = Activity.find_by_uuid(params["activity_uuid"])
        state = 1
        if activity
          @banners = Banner.where(:activity_id => activity.id,:state => state)
          if @banners.count > 0
            num = rand @banners.count
            @choice = @banners[num]
          end
        end
      end
      # ===================post '/banners/draw'=================

    end

  end

end
