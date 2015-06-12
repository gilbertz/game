module CUSTOMER
  module Teamwork
    class TeamworkAPI < Grape::API
      version 'v1'
      #------------------helpers------------------
      helpers do
      end

      #------------------resources material------------------
      resources :teamwork do
        #--------------------post :start do-----------------
        desc '开启一个团队合作模式'
        params do
        end
        post :start ,jbuilder:'material/teamwork_start' do
          if current_material
            @material = current_material
            @category = @material.category
            # 团队协作类型的模版
            if @category.game_type_id = 17
              # 如果存在团队协作未完成
              @exist_teamwork = Teamwork.where(:sponsor =>current_user.id,:material_id =>@material.id,:state => 0).first
               unless @exist_teamwork
                 init_percents = @material.teamworks_rand
                 total_work = @material.total_work
                 @teamwork = Teamwork.create_teamwork(current_user.id, @material.id, init_percents, total_work)
                end
            end

          end

        end
        #--------------------get :start do-----------------

        #--------------------post :join do---------------
        desc '加入一个团队合作模式'
        params do
          requires :sponsor, type: String, allow_blank: false, desc: "团队接龙发起者"
        end
        post :join ,jbuilder:'material/teamwork_join' do
          if current_material
            @material = current_material
            @category = @material.category
            # 团队协作类型的模版
            if @category.game_type_id = 17
               @exist_teamwork = Teamwork.where(:sponsor =>current_user.id,:material_id =>@material.id,:state => 0).first
               if @exist_teamwork && @material.team_persons && @exist_teamwork.partners.count < @material.team_persons
                 # 访问排重
                 loop do
                   if $redis.get("teamwork_#{@material.id}_#{@exist_teamwork.id}") != '1'
                        $redis.set("teamwork_#{@material.id}_#{@exist_teamwork.id}",'1')
                        break
                   end
                  end
                 @exist_teamwork.add_partner(current_user.id)
                 @exist_teamwork.save
                 $redis.expire("teamwork_#{@material.id}_#{@exist_teamwork.id}")
               end
            end
          end
        end
        #--------------------post :join do---------------



      end
      #------------------resources teamwork------------------


    end

  end

end