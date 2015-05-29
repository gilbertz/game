module API
  module RedPack
    class RedpackAPI < Grape::API
      version      'v1'

      helpers do
      end

      resource :redpack do

        desc "发送种子红包 德高"
        params do
          requires :beacon_url, type: String, desc: "ibeacon的url"
          requires :game_url, type: String, desc: "游戏url"
        end
        get '/send_seed_redpack' do
          beacon_id = Ibeacon.get_beacon(params[:beacon_url])
          game_id = Material.get_game(params[:game_url])
          object = Material.get_object(params[:game_url])
          redpack_time = RedpackTime.get_redpack_time(object.id)
          person_num = redpack_time.person_num if redpack_time
          check_state = Check.find_by(user_id: current_user.id, beaconid: beacon_id,state: 1,game_id: game_id)
          check_num = Check.check_per_day(current_user.id, game_id, beacon_id)
          if check_num <= person_num and check_state
            check_state.update(:state => 0) 
            info = Redpack.gain_seed_redpack(current_user.id, game_id, object.id, beacon_id)
            money = Redpack.find(object.id).weixin_post(current_user,beacon_id,info) if info > WEIXIN_REDPACK_RESTRICTION_VALUE
            return {'info' => money }
          else 
            return {'info' => 0 }
          end 
        end

        desc "发送社交红包 德高"
        params do 
          requires :beacon_url, type: String, desc: "ibeacon的url"
          requires :game_url, type: String, desc: "游戏url"
        end
        get '/send_social_redpack' do
          beacon_id = Ibeacon.get_beacon(params[:beacon_url])
          game_id = Material.get_game(params[:game_url])
          total_score = UserScore.find_by("user_id = ? and beaconid = ?", current_user.id, beacon_id).total_score  
          if(total_score >= 100)
            Score.create(:user_id => current_user.id, :from_user_id => current_user.id, :beaconid=> beacon_id, :value => -total_score, :game_id => game_id)
            UserScore.find_by("user_id = ? and beaconid = ?", current_user.id, beacon_id).update(:total_score => 0) 
            Record.create(:user_id => current_user.id, :from_user_id => current_user.id, :beaconid=> beacon_id, :game_id => game_id, :score => -total_score, :object_type=> 'social_redpack', :object_id => @object.id)
            total_score = total_score > 300 ? 300 : total_score
            Redpack.find(@object.id).weixin_post(current_user, beacon_id,total_score)
            current_user.mark_scores(beacon_id, game_id)
          end
          return {'info' => total_score}
        end

        desc "红包首页配置 德高"
        params do 
          requires :beacon_url, type: String, desc: "ibeacon的url"
          requires :game_url, type: String, desc: "游戏url"
        end
        get '/get_time_amount' do
          beacon_id = Ibeacon.get_beacon(params[:beacon_url])
          p beacon_id
          game_id = Material.get_game(params[:game_url])
          check_today = Check.check_today(current_user.id,game_id,beacon_id)
          check_three = Check.check_three(current_user.id,game_id,beacon_id)
          time_amount = TimeAmount.get_time(game_id)
          return unless @time_amount
          end_time = @time_amount.time
          now_time = Time.now
          amount = TimeAmount.get_amount(game_id, beacon_id)
          checked = Check.check_state(current_user.id, game_id, beacon_id)  > 0 ? 1:0
          fake_amount = (@amount + 100000)/100 
          p fake_amount
          Redpack.distribute_seed_redpack(beacon_id, object_id, game_id)
          return {'check_today' => check_today, 'check_three' => check_three, 'time_amount' => time_amount, 'end_time' => end_time, 'now_time' => now_time, 'amount' => amount, 'checked' => checked, 'fake_amount' => fake_amount}
        end 
      end

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

        desc "show_consume"
        get '/show_consume/:rp_id' do
          $redis.lrange("hongBaoConsumedList_#{rp_id}",0,-1).length
        end

        desc "delete_redpack"
        get '/delete_redpack/:rp_id' do
          $redis.del("hongbaolist_#{rp_id}")
          $redis.del("hongBaoConsumedMap_#{rp_id}")
          $redis.del("hongBaoConsumedList_#{rp_id}")
        end
      end

    end
  end

end