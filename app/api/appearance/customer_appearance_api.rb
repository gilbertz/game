module CUSTOMER

  module Appearance

    class AppearanceAPI < Grape::API
      version 'v1'
      #------------------helpers------------------
      helpers do

      end
      #------------------resources appearance------------------
      resources :appearance do
        #--------------------get :current_material do-----------------
        desc '获取应用的外观设置'
        params do
          optional :activity_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
          optional :component_uuid, type: String, allow_blank: false, desc: "组件唯一标识."
          exactly_one_of :activity_uuid, :component_uuid
        end
        get '/' ,jbuilder:'appearance/get' do
          auuid = params["activity_uuid"]
          cuuid = params["component_uuid"]
          if auuid
            activity = Activity.find_by_uuid(auuid)
            @activity_appearance = Appearance.find_by_id(activity.appearance_id)
          end
          if cuuid
            component = Component.find_by_uuid(cuuid)
            @component_appearance = Appearance.find_by_id(component.appearance_id)
          end
        end
        #--------------------get '/' do-----------------

      end
      #------------------resources appearance------------------


    end

  end

end