module API 

  module ActivityCheck 

    class ActivityCheckAPI <  Grape::API 

      version 'v1'
      helpers  do
      end

      resources :check do 

        desc "新建活动报名签到"
        params do
          requires :beacon_url, type: String, desc: "ibeacon的url"
          requires :game_url, type: String, desc: "游戏url"
        end
        post do 
          beacon_id = Ibeacon.get_beacon(params[:beacon_url])
          game_id = Material.get_game(params[:game_url])
          Check.create!({user_id: current_user.id , beaconid: beacon_id, game_id: game_id, state: 1})
        end

        desc "查看报名签到次数"
        params do 
          requires :beacon_url, type: String, desc: "ibeacon的url"
          requires :game_url, type: String, desc: "游戏url"
          optional :time_begin, type: Time, desc: "查询开始时间"
          optional :time_end, type: Time, desc: "查询结束时间"
          requires :is_today, type: Boolean, default: true, desc: "是否查询今天报名"
          requires :state, type: Integer, desc: "查询状态"
        end  
        get '/:user_id' do 
          user_id = params[:user_id]
          beacon_id = Ibeacon.get_beacon(params[:beacon_url])
          game_id = Material.get_game(params[:game_url])
          state = params[:state]
          if params[:is_today]
            Check.where("user_id = ? and game_id = ? and beaconid = ? and state = ? and created_at >= ? and created_at <= ? ",current_user.id, game_id, beacon_id, state, Date.today.beginning_of_day, Date.today.end_of_day).length 
          else
            if params[:time_begin] and params[:time_end]
              Check.where("user_id = ? and game_id = ? and beaconid = ? and state = ? and created_at >= ? and created_at <= ?",current_user.id, game_id, beacon_id, state ,params[:time_begin], params[:time_end]).length 
            else
              Check.where("user_id = ? and game_id = ? and beaconid = ? and state = ? ", current_user.id, game_id, beacon_id, state).length 
            end
          end  
        end

        desc "规定次数新建活动报名签到 德高"
        # params do 
        #   requires :beacon_url, type: String, desc: "ibeacon的url"
        #   requires :game_url, type: String, desc: "游戏url"
        # end
        before do
          user_agent!
          request_headers!
          # wizarcan_sign!
        end
        post '/dgbs' do 
          beacon_id = current_material.beacon_id
          game_id = current_material.id
          object = Redpack.find(:material_id => current_material.id)
          redpack_time = RedpackTime.get_redpack_time(object.id)
          person_num = redpack_time.person_num if redpack_time
          if Check.check_per_day(current_user.id,game_id,beacon_id)< person_num
            unless Check.check_state(current_user.id, game_id, beacon_id) > 0
              Check.create(user_id: current_user.id, beaconid: beacon_id, state: 1,game_id: game_id) 
              return {'result' => 0 ,'info' => "报名成功",'name' => current_user.name} 
            else
              return {'result' => -1 ,'info' => "已经报过名了",'name' => current_user.name} 
            end
          else 
            return {'result' => -1 ,'info' => "今日报名超过次数",'name' => current_user.name}
          end
        end

        end

      end

    end

  end
