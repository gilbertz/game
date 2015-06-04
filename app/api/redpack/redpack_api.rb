module API
  module RedPack
    class RedpackAPI < Grape::API
      version      'v1'

      helpers do
      end
 
      resource :redpack do

#-------------------新建红包------------------#

        params do 
          #  "创建红包设计"
          requires :beaconid, type: Integer, desc: "beaconid"

          requires :redpack_appearance, type: Hash do
            requires :title, type: String, desc: "红包标题"
            requires :wish, type: String, desc: "红包祝福语"
            requires :avator, type: String, desc: "头像图片地址"
          end

          # "创建红包设置"
          requires :redpack_option, type: Hash do
            requires :amount, type: Integer, desc: "红包总额"
            requires :store, type: Integer, desc: "红包个数"
            optional :random, type: Hash do
              requires :max, type: Integer, desc: "最大金额"
              requires :min, type: Integer, desc: "最小金额"
            end
            optional :equal, type: Hash do
              requires :money, type: Integer, desc: "等额金额"
            end
            optional :manual, type: Hash do
              requires :money, type: Array[Integer], desc: "手动金额"
            end
            exactly_one_of :random, :equal, :manual
          end

          # 考虑单个时间段和多个时间段
          # "创建红包发送设置" 
          requires :redpack_send, type: Hash do
            requires :send_start_time, type: Time, desc: "发送开始时间"
            requires :send_end_time, type: Time, desc: "发送结束时间"
            requires :send_prepare_time, type: Time, desc: "预热时间"
          end

          # 考虑每个用户单个时间领取最大，或者整个时间段领取最大，或者全天领取最大
          # "创建红包领取设置"
          requires :redpack_get, type: Hash do
            requires :person_num, type: Integer, desc: "单个用户最多摇到的次数"
            optional :immediate_get
            optional :random_get, type: Hash do
              requires :probability, type: Integer, desc: "中奖概率"
            end
            exactly_one_of :immediate_get, :random_get
          end
        end

        post '/create' do 
          
          @redpack = Redpack.new
          @redpack.merchant_id = current_user.id
          @redpack.material_id = current_materail.id
          @redpack_appearance = RedpackAppearance.new
          @redpack_appearance.redpack_id = @redpack.id
          @redpack_appearance.title = params[:title]
          @redpack_appearance.wish = params[:wish]
          @redpack_appearance.avator = params[:avator]
          @redpack_appearance.save

          @redpack_option = RedpackOption.new
          @redpack_option.redpack_id = @redpack.id
          @redpack_option.amount = params[:amount]
          @redpack_option.store = params[:store]
          if params[:random]
            @redpack_option.rule = 'random'
            @redpack_option.max = params[:max]
            @redpack_option.min = params[:min]
          elsif params[:equal]
            @redpack_option.rule = 'equal'
            @redpack_option.money = params[:money].to_s
          elsif params[:manual]
            @redpack_option.rule = 'manual'
            @redpack_option.money = params[:money].join(',')
          end  
          
          @redpack_send = RedpackSend.new
          @redpack_send.redpack_id = @redpack.id
          @redpack_send.send_start_time = params[:send_start_time]
          @redpack_send.send_end_time = params[:send_end_time]
          @redpack_send.send_prepare_time = params[:send_prepare_time]

          @redpack_get = RedpackGet.new
          @redpack_get.redpack_id = @redpack.id
          @redpack_get.person_num = params[:person_num]
          if params[:immediate_get]
            @redpack_get.rule = 'immediate_get'
          else 
            @redpack_get.rule = 'random_get'
            @redpack_get.probability = params[:probability]
          end

          Material.create(:merchant_id => current_user.id, :beaconid => params[:beaconid], :appearance_type => "RedpackAppearance", :appearance_id => @redpack_appearance.id, :object_type => "Redpack", :object_id => @redpack.id)
        end


#-------------------历史红包------------------#

        desc "查看红包"
        get '/history'do 
          json_redpacks = []
          redpacks = Redpack.includes(:redpack_appearance,:redpack_option,:redpack_send,:redpack_get).where( " party_id = ? and redpack_send.send_end_time <= ?", current_user.id, Time.now ).order("created_at desc")
          redpacks.each do |redpack|
            json_redpack.push({"redpack_id" => redpack.id, "title" => redpack.redpack_appearance.title, "send_start_time" => redpack.redpack_send.send_start_time, "send_end_time" => redpack.redpack_send.send_end_time, "created_at" => redpack.created_at})
          end
          json_redpacks
        end

        desc "查看详情"
        get '/history/:redpack_id'do 
          RedpackRecord.where(:redpack_id => redpack_id).order("created_at desc")
        end


#-------------------修改红包------------------#
        desc "查看红包"
        get '/edit'do
        end

        desc "修改红包"
        params do
        end
        post '/edit/:redpack_id' do
        end


#-------------------删除红包------------------#
        desc "删除红包"
        get '/delete' do
        end


#-------------------发送准备------------------#

        desc "红包首页配置 德高"
        post '/get_time_amount' do
        p "GGGGGGGG" 
 beacon_id = current_material.beacon_id
         p "vv" 
game_id = current_material.id
          @object = Redpack.find_by(:material_id => current_material.id)
          check_today = Check.check_today(current_user.id,game_id,beacon_id)
          check_three = Check.check_three(current_user.id,game_id,beacon_id)
          @time_amount = TimeAmount.get_time(game_id)
          unless @time_amount 
            return {'result' => -1, 'info' => "没有time_amount"}
          end
          end_time = @time_amount.time
          now_time = Time.now
          @amount = TimeAmount.get_amount(game_id, beacon_id)
          checked = Check.check_state(current_user.id, game_id, beacon_id)  > 0 ? 1:0
          fake_amount = (@amount + 100000)/100 
          Redpack.distribute_seed_redpack(beacon_id, @object.id, game_id)
          p fake_amount 
return {'check_today' => check_today, 'check_three' => check_three, 'time_amount' => time_amount, 'end_time' => end_time, 'now_time' => now_time, 'amount' => amount, 'checked' => checked, 'fake_amount' => fake_amount}
        end 


#-------------------发送红包------------------#
        desc "发送种子红包 德高"
        before do
          # user_agent!
          # request_headers!
          # wizarcan_sign!
        end
        post '/send_seed_redpack' do
          beacon_id = current_material.beacon_id
          game_id = current_material.id
          @object = Redpack.find_by(:material_id => current_material.id)
          redpack_time = RedpackTime.get_redpack_time(@object.id)
          person_num = redpack_time.person_num if redpack_time
          check_state = Check.find_by(user_id: current_user.id, beaconid: beacon_id,state: 1,game_id: game_id)
          check_num = Check.check_per_day(current_user.id, game_id, beacon_id)
          if check_num <= person_num and check_state
            check_state.update(:state => 0) 
            info = Redpack.gain_seed_redpack(current_user.id, game_id, @object, beacon_id)
            money = Redpack.find(@object.id).weixin_post(current_user.id,beacon_id,info) if info > WEIXIN_REDPACK_RESTRICTION_VALUE
            return {'result' => 0, 'money' => money, 'info' => "成功发送种子红包"}
          else 
            return {'result' => -1, 'money' => 0, 'info' => "没有报名或者今天次数已经到限制"  }
          end 
        end
        
        desc "记录社交红包、发送反馈红包"
        params do
          optional :openid, type: String, desc: "用户openid"
        end
        before do
          #user_agent!
          #request_headers!
          # wizarcan_sign!
        end
        post '/record_social_and_send_feedback_redpack' do
          if current_user
            beacon_id = current_material.beacon_id
            game_id = current_material.id
            @object = Redpack.find_by(:material_id => current_material.id)
            if params[:openid]
              au = Authentication.find_by_uid( params[:openid] )
              if au
                from_user_id = au.user_id
                from_user = User.find from_user_id
                if params[:beacon_url] == 'dgbs'
                   @score = Score.find_by(:beaconid=>beacon_id, :from_user_id =>au.user_id, :user_id =>current_user.id)
                   if not @score and from_user.social_value(beacon_id) > 0
                      r = Record.where(:beaconid=>beacon_id, :user_id =>au.user_id, :object_type => 'Redpack', :feedback => nil).order('created_at desc')[0]
                      f_value = 100 + rand(50)
                      f_value = (r.score/2 < 100)?100:r.score/2 if r
                      from_user.decr_social(beacon_id)
                      if from_user.social_value(beacon_id) % 3 == 0
                        @rp = @object.weixin_post(from_user.id, beacon_id, f_value)
                        if r
                          r.feedback = 1
                          r.save
                        end
                        Record.create(:user_id => from_user_id, :beaconid=>beacon_id, :game_id => game_id, :score => @rp, :object_type=>'f_redpack', :object_id => rp.id)
                      end
                    else
                      f_value = 0
                    end
                  end
                  Score.create(:user_id =>current_user.id, :from_user_id =>from_user_id, :beaconid=>beacon_id, :game_id => params[:game_id], :value => f_value)
                end
              end
              {'value' => f_value }
            else
            {'result' => 'not current_user or score' }
          end
        end

        desc "发送社交红包 德高"
        before do
          user_agent!
          request_headers!
          # wizarcan_sign!
        end
        post '/send_social_redpack' do
          beacon_id = current_material.beacon_id
          game_id = current_material.id
          @object = Redpack.find_by(:material_id => current_material.id)
          total_score = UserScore.find_by("user_id = ? and beaconid = ?", current_user.id, beacon_id).total_score  
          if(total_score >= 100)
            Score.create(:user_id => current_user.id, :from_user_id => current_user.id, :beaconid=> beacon_id, :value => -total_score, :game_id => game_id)
            UserScore.find_by("user_id = ? and beaconid = ?", current_user.id, beacon_id).update(:total_score => 0) 
            Record.create(:user_id => current_user.id, :from_user_id => current_user.id, :beaconid=> beacon_id, :game_id => game_id, :score => total_score, :object_type=> 'social_redpack', :object_id => @object.id)
            total_score = total_score > 300 ? 300 : total_score
            Redpack.find(@object.id).weixin_post(current_user.id, beacon_id,total_score)
            current_user.mark_scores(beacon_id, game_id)
          end
          return { 'result' => 0, 'info' => total_score}
        end
      end


#-------------------测试红包------------------#

      resource :test_redpack do
   
        desc "test_generate"
        get '/test_generate' do
          result_hongbao = Redpack.generate(params[:total].to_i, params[:count].to_i, params[:max].to_i, params[:min].to_i, params[:rp_id].to_i)
        end

        desc "test_seed_redpack"
        get '/test_seed_redpack/:rp_id' do
          Redpack.test(params[:id],params[:rp_id])
        end

        desc "show_generate_length"
        get '/show_generate_length/:rp_id' do
          $redis.lrange("hongbaolist_#{params[:rp_id]}",0,-1).length
        end

        desc "show_generate"
        get '/show_generate/:rp_id' do
          $redis.lrange("hongbaolist_#{params[:rp_id]}",0,-1)
        end

        desc "show_consumed_list"
        get '/show_consumed_list/:rp_id' do
          $redis.lrange("hongBaoConsumedList_#{params[:rp_id]}",0,-1)
        end

        desc "show_consume_map"
        get '/show_consume_map/:rp_id' do
          $redis.hget("hongBaoConsumedMap_#{params[:rp_id]}",current_user.id)
        end

        desc "delete_redpack"
        get '/delete_redpack/:rp_id' do
          $redis.del("hongbaolist_#{params[:rp_id]}")
          $redis.del("hongBaoConsumedMap_#{params[:rp_id]}")
          $redis.del("hongBaoConsumedList_#{params[:rp_id]}")
        end
      end

    end
  end

end
