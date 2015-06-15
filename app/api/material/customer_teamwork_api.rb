module CUSTOMER
  module Teamworks
    class TeamworkAPI < Grape::API
      version 'v1'
      #------------------helpers------------------
      helpers do
        #获取用户目前参与的团队任务
        def self_in_teamwork(user_id,matterial_id)
          teamwork_id = $redis.get(teamwork_key(user_id,matterial_id))
          if teamwork_id
            t = Teamwork.find_by_id(teamwork_id)
            if t && t.state == 0
              t
            end
          end
        end


        def teamwork_key(use_id,matterial_id)
          "teamwork_#{matterial_id}_#{use_id}"
        end


        #用于同时加入某个团队协作排重
        def teamwork_lock_key(teamwork_id,matterial_id)
          "teamwork_lock_#{matterial_id}_#{teamwork_id}"
        end

      end

      #------------------resources material------------------
      resources :teamwork do
        #--------------------post :start do-----------------
        desc '开启或加入一个团队合作模式'
        params do
          optional :from_user,type: String,allow_blank: false,desc: '团队接龙发起者'
        end
        get :start ,jbuilder:'material/teamwork_start' do
          @flag = -1
          p "current user = #{current_user.to_json}"
          p "current_material = #{current_material.to_json}"
          if current_material
            @material = current_material
            @category = @material.category
            # 团队协作类型的模版
            if @category.game_type_id = 17
              @exist_teamwork = self_in_teamwork(current_user.id,@material.id)
              p "@exist_teamwork = #{@exist_teamwork.to_json}"
              if @exist_teamwork
                @flag = 0
              else
                #如果是加入到别人创建好的团队中
                from_user = User.by_openid(params["from_user"])
                if from_user && from_user.id != current_user.id
                  @flag = 1
                  @exist_teamwork = self_in_teamwork(from_user.id,@material.id)
                  # 访问排重
                  loop do
                    if $redis.get(teamwork_lock_key(@exist_teamwork.id,@material.id)) != '1'
                      $redis.set(teamwork_lock_key(@exist_teamwork.id,@material.id),'1')
                      break
                    end
                  end
                  if @exist_teamwork && @material.team_persons && @exist_teamwork.partners.count < @material.team_persons

                    @exist_teamwork.add_partner(current_user.id)
                    @exist_teamwork.save
                  # teamwork 已经不存在了
                  else
                    @flag = 3
                  end
                  $redis.expire(teamwork_lock_key(@exist_teamwork.id,@material.id))
               #自己创建一个
                else
                  @flag = 2
                  init_percents = @material.teamworks_rand
                  total_work = @material.total_work
                  @teamwork = Teamwork.create_teamwork(current_user.id, @material.id, init_percents, total_work)
                  if @teamwork
                    $redis.set(teamwork_key(current_user.id, @material.id),@teamwork.id)
                    p "redis get #{$redis.get(teamwork_key(current_user.id, @material.id))}"
                  end
                end
              end
            end#if @category.game_type_id = 17
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


        #---------------------post :结果




      end
      #------------------resources teamwork------------------


    end

  end

end
