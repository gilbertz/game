module API 

  module Statis

    class StatisAPI <  Grape::API 

      version 'v1'
      helpers  do
      end
     
      resource :statis do 
        desc "统计红包浏览量、种子红包、社交红包、反馈红包"
        params do
          requires :beacon_url, type: String, desc: "beacon的url" 
          requires :game_url, type: String, desc: "游戏url"
          optional :end_date, type: Date, desc: "结束时间"
          optional :start_date, type: Date, desc: "开始时间"
        end
        get "/:beacon_url/:game_url" , jbuilder: 'statis/game_statis'do
          beacon_id = Ibeacon.get_beacon(params[:beacon_url]) 
          game_id = Material.get_game(params[:game_url])
          # end_date = Date.parse(params[:end_date] || Date.today().to_s)
          # start_date = Date.parse(params[:start_date] || (end_date - 30).to_s)
          end_date = Time.now
          start_date = Time.now-24*3600*10
          @name = Material.find_by_id(game_id).name
          @uv = Uv.where("created_at >= ? and created_at <= ? and game_id = ? and beaconid = ?", start_date, end_date, game_id, beacon_id)
          @record = Record.where("created_at >= ? and created_at <= ? and game_id = ? and beaconid =? ",start_date, end_date, game_id ,beacon_id)
          @uv_sub_group = []
          @record_sub_group = []
          uv_groups = @uv.group_by{|date| date.created_at.strftime("%Y %m %d")}
          uv_groups.each {|key,value| @uv_sub_group.push({"created_at" => key, "per_num" => value.length, "person_num" => value.as_json.each{|a| a.select!{|k,v| k =="user_id"}}.uniq.length})}
          record_groups = @record.group_by{|date| date.created_at.strftime("%Y %m %d")}
          record_groups.each {|key,value| @record_sub_group.push({"created_at" => key, "seed_redpack_num" => value.as_json.select{|a| a["object_type"] == "Redpack"}.length, "social_redpack_num" => value.as_json.select{|a| a["object_type"] == "social_redpack"}.length, "feedback_redpack_num" => value.as_json.select{|a| a["object_type"] == "f_redpack"}.length, "seed_redpack" => value.as_json.select{|a| a["object_type"] == "Redpack"}.collect{|a| a["score"]}.reduce(:+), "social_redpack" => value.as_json.select{|a| a["object_type"] == "social_redpack"}.collect{|a| a["score"]}.reduce(:+), "feedback_redpack" => value.as_json.select{|a| a["object_type"] == "f_redpack"}.collect{|a| a["score"]}.reduce(:+)})}

        end
      end





    end

  end
end