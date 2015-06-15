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
            if t && t.is_runing?
              t
            end
          end
        end

        def reset_teamwork_partners(teamwork,matterial_id)
          if teamwork
            arr = teamwork.partners
            arr.each { |item|  $redis.expire(teamwork_key(item.to_i,matterial_id)) }

          end
        end

        def teamwork_key(user_id,matterial_id)
          "teamwork_#{matterial_id}_#{user_id}"
        end

        def last_teamwork_key(user_id,matterial_id)
          "last_teamwork_#{matterial_id}_#{user_id}"
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
        post :start ,jbuilder:'material/teamwork_start' do
          @flag = -1
          p "current user = #{current_user.to_json}"
          p "current_material = #{current_material.to_json}"
          if current_material
            @material = current_material
            @category = @material.category
            # 团队协作类型的模版
            if @category.game_type_id = 17
              @teamwork = self_in_teamwork(current_user.id,@material.id)
              p "@exist_teamwork = #{@teamwork.to_json}"
              if @teamwork
                @flag = 0
                @partner_users = @teamwork.partner_users
              else
                #如果是加入到别人创建好的团队中
                from_user = User.by_openid(params["from_user"])
                if from_user && from_user.id != current_user.id
                  @flag = 1
                  @teamwork = self_in_teamwork(from_user.id,@material.id)
                  # 访问排重
                  loop do
                    if $redis.get(teamwork_lock_key(@teamwork.id,@material.id)) != '1'
                      $redis.set(teamwork_lock_key(@teamwork.id,@material.id),'1')
                      break
                    end
                  end
                  if @teamwork && @material.team_persons && @teamwork.partners.count < @material.team_persons
                    @teamwork.add_partner(current_user.id)
                    if @teamwork.save
                      $redis.set(last_teamwork_key(current_user.id, @material.id),@exist_teamwork.id)
                      @partner_users = @teamwork.partner_users
                    end
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
                    @partner_users = @teamwork.partner_users
                    $redis.set(teamwork_key(current_user.id, @material.id),@teamwork.id)
                    $redis.set(last_teamwork_key(current_user.id, @material.id),@teamwork.id)
                    p "redis get #{$redis.get(teamwork_key(current_user.id, @material.id))}"
                  end
                end
              end
            end#if @category.game_type_id = 17
          end
        end
        #--------------------get :start do-----------------



        #--------------------post :history do---------------
        desc '历史活动'
        get :history ,jbuilder:'material/teamwork_history' do
          if current_material
            @material = current_material
            @category = @material.category
            # 团队协作类型的模版
            if @category.game_type_id = 17
              team_id = $redis.get(last_teamwork_key(current_user.id,@material.id))
              if team_id
                @exist_teamwork = Teamwork.find_by_id(team_id)
                if @exist_teamwork
                  @partner_users = @exist_teamwork.partner_users
                end
              end
            end
          end
        end
        #--------------------post :history do---------------


        #---------------------post :submit_percent do ---------------------
        params do
          requires :percent,type: Integer,allow_blank: false,desc: '提交结果'
        end
        post :submit_percent ,jbuilder:'material/teamwork_submit_percent' do
          @flag = -1
          if current_material
            @material = current_material
            @category = @material.category
            if @category.game_type_id = 17
              @exist_teamwork = self_in_teamwork(current_user.id,@material.id)
              if @exist_teamwork
                result_percent = @exist_teamwork.rand_result_percent(current_user.id,params["percent"])
                @exist_teamwor.set_result_percent(current_user.id,result_percent)
                @expect_percent =  @exist_teamwork.get_user_percent(current_user.id)
                if @expect_percent && @expect_percent.to_f <= result_percent
                  # 过关
                  @flag = 0
                  if @exist_teamwork.partners.count >= @material.team_persons.count
                    # 成功完成
                    @flag = 1
                    @exist_teamwork.state = 1
                  end
                else
                  # 失败结束
                  @flag = 2
                  @exist_teamwork.state = 2
                end

                if @exist_teamwork.save
                  @partner_users = @exist_teamwork.partner_users
                  # 成功完成 或者失败完成  要把 redis归位
                  if @flag == 1 || @flag == 2
                    reset_teamwork_partners(@exist_teamwork,@material.id)
                  end
                  # 成功完成 还要发钱
                  if @flag == 1
                    # 开始发钱

                  end
                else
                  @flag = -1
                end
              end
            end


          end

        end
        #---------------------post :submit_percent do ---------------------


      end
      #------------------resources teamwork------------------


    end

  end

end
