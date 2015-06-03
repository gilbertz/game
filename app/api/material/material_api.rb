module API

  module MaterialInfo

    class MaterialInfoAPI < Grape::API
      version 'v1'
      #------------------helpers------------------
      helpers do

      end


      #------------------resources material------------------
      resources :material do
        #--------------------get :current_material do-----------------
        desc '获取当前material的外观设置'
        params do
        end
        get :current_material ,jbuilder:'material/appearance' do
          if current_material
            if not current_material.object_type.blank? and current_material.object_id
              @object = current_material.object_type.capitalize.constantize.find current_material.object_id
            end
          end

        end
        #--------------------get :current_material do-----------------

      end
      #------------------resources material------------------


    end

  end

end