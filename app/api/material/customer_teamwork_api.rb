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
            arr.each { |item|  $redis.set(teamwork_key(item.to_i,matterial_id),nil) }
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


        def teamwork_can_json?(teamwork)
          if teamwork
            arr = teamwork.partners
            if arr.count > 0
              p "arr.count > 0 and p #{teamwork.get_result_percent(arr.last)}"
              f = teamwork.get_result_percent(arr.last)
	             if f.to_f > 0.0
                return  true
              end
            end
          end
          false
        end

        def join_teamwork_time_key(teamwork_id,user_id)
          "join_teamwork_time_key_#{teamwork_id}_#{user_id}"
        end

        def get_join_teamwork_time(teamwork_id,user_id)
          $redis.get(join_teamwork_time_key(teamwork_id,user_id))
        end

        def set_join_teamwork_time(teamwork_id,user_id)
          i = Time.now.to_i
          $redis.set(join_teamwork_time_key(teamwork_id,user_id),i)
        end


        def deal_expire_user(teamwork_id,user_id)
          teamwork = Teamwork.find_by(teamwork_id)
          p "teamwork = #{teamwork.to_json}"
          if teamwork.is_over? == false
            arr = teamwork.partners
            if (teamwork.get_result_percent(arr.last)).to_f <= 0.0 && arr.last.to_i != user_id.to_i
              last_time = get_join_teamwork_time(teamwork.id,arr.last)
              now_time = Time.now.to_i
              p "last_time = #{last_time}"
              if last_time != nil && now_time - last_time.to_i > 60
                teamwork.set_result_percent(arr.last,0)
                arr.pop
                teamwork.partner = arr.join(',')
                if teamwork.save
                  p "now teamwork = #{teamwork}"
                  $redis.set(teamwork_key(user_id,current_material.id),nil)
                  return teamwork
                end
              end
            end

          end
        end

      end

      #------------------resources material------------------
      resources :teamwork do
        #--------------------post :start do-----------------
        desc '开启或加入一个团队合作模式'
        params do
          optional :from_user,type: String,desc: '团队接龙发起者'
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
                p "@partner_users #{@partner_users.to_json}"
              else
                #如果是加入到别人创建好的团队中
                from_user = User.by_openid(params["from_user"])
                if from_user && from_user.id != current_user.id
                  @flag = 1
                  @teamwork = self_in_teamwork(from_user.id,@material.id)
                  deal_expire_user(@teamwork.id,current_user.id)
                  # 访问排重
                  lock_key = $redis.get(teamwork_lock_key(@teamwork.id,@material.id))
                  p "fromuser = #{from_user.to_json}  can join #{teamwork_can_json?(@teamwork)}"
                  if lock_key != '1' && teamwork_can_json?(@teamwork) && @material.team_persons && @teamwork.partners.count < @material.team_persons
                    $redis.set(teamwork_lock_key(@teamwork.id,@material.id),'1')
                    @teamwork.add_partner(current_user.id)
                    if @teamwork.save
                      $redis.set(last_teamwork_key(current_user.id, @material.id),@teamwork.id)
                      $redis.set(teamwork_key(current_user.id, @material.id),@teamwork.id)
                      @partner_users = @teamwork.partner_users
                      set_join_teamwork_time(@teamwork.id,current_user.id)
                    end
                  # teamwork 已经不存在了
                  else
                    @flag = 3
                  end
                  $redis.set(teamwork_lock_key(@teamwork.id,@material.id),nil)
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
        params do
          optional :from_user,type: String,desc: '团队接龙发起者'
        end
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
                  t =  deal_expire_user(@exist_teamwork.id,current_user.id)
                  if t
                    @exist_teamwork = t
                  end
                  @partner_users = @exist_teamwork.partner_users
                  @ower = current_user
                end
                from_user = User.by_openid(params["from_user"])
                p "from_user = #{from_user}"
                if from_user && from_user.id != current_user.id && self_in_teamwork(from_user.id,@material.id) && @exist_teamwork.is_over?
                  @is_goon = 1
                else
                  @is_goon = 0
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
              # 存在并且无提交过成绩
              if @exist_teamwork && (@exist_teamwork.get_result_percent(current_user.id)).to_f <= 0.0
                result_percent = @exist_teamwork.rand_result_percent(current_user.id,params["percent"],current_user.id.to_i == @exist_teamwork.sponsor.to_i)
                @exist_teamwork.set_result_percent(current_user.id,result_percent)
                # @expect_percent =  @exist_teamwork.get_user_percent(current_user.id)
                if  result_percent
                  # 过关
                  @flag = 0
                  if @exist_teamwork.partners.count >= @material.team_persons
                    if @exist_teamwork.results_sum > 1.0
                      # 成功完成
                      @flag = 1
                      @exist_teamwork.state = 1
                    else
                      # 失败结束
                      @flag = 2
                      @exist_teamwork.state = 2
                    end
                  end
                end
                if @exist_teamwork.save
                  @partner_users = @exist_teamwork.partner_users
                  # 成功完成 或者失败完成  要把 redis归位
                  if @flag == 1 || @flag == 2
                    reset_teamwork_partners(@exist_teamwork,@material.id)
                  end
                  # 成功完成 还要发钱
                  if @flag == 1 && @material.team_reward && @material.team_reward.to_i > 4
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
