module API 

  module Behaviour 

    class CheckAPI <  Grape::API 

      version 'v1'
      helpers  do
  
      end

      resources :check do 

        desc "新建活动报名签到"
        params do
        requires :user_id, type: Integer, desc: "用户id"
        requires :beacon_id, type: Integer, desc: "ibeacon的id"
        requires :game_id, type: Integer, desc: "游戏id"
        end
        post do 
        Check.create!({user_id: params[:user_id], beaconid: params[:beacon_id], game_id: params[:game_id], state: 1})
        end

        desc "查看报名签到状态"
        params do 
          requires :user_id, type: Integer, desc: "用户id"
          requires :beacon_id, type: Integer, desc: "ibeacon的id"
          requires :game_id, type: Integer, desc: "游戏id"
          optional :time_begin, type: Time, desc: "查询开始时间"
          optional :time_end, type: Time, desc: "查询结束时间"
          requires :is_today, type: Boolean, default: true, desc: "是否查询今天报名"
          requires :state, type: Integer, desc: "查询状态"
        end  
        get '/:user_id' do 
          if params[:is_today]
            Check.where("user_id = ? and game_id = ? and beaconid = ? and state = ? and created_at >= ? and created_at <= ? ",params[:user_id], params[:game_id], params[:beacon_id], params[:state], Date.today.beginning_of_day, Date.today.end_of_day).length 
          else
            if params[:time_begin] and params[:time_end]
            Check.where("user_id = ? and game_id = ? and beaconid = ? and state = ? and created_at >= ? and created_at <= ?",params[:user_id], params[:game_id], params[:beacon_id], params[:state] ,params[:time_begin], params[:time_end]).length 
            else
              Check.where("user_id = ? and game_id = ? and beaconid = ? and state = ? ",params[:user_id], params[:game_id], params[:beacon_id], params[:state] ).length 
            end
          end
          
        end


      end

    end
  
  end

end
