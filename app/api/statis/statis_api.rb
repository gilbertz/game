

module API 

  module Statis

    class StatisAPI <  Grape::API 
      version 'v1'
      helpers  do
        def uv_key(beacon_id=0, game_id=0, day, item)
          "uv_#{beacon_id}_#{game_id}_#{day}_#{item}"
        end

        def record_key(beacon_id=0, game_id=0, day, item )
          "record_#{beacon_id}_#{game_id}_#{day}_#{item}"
        end

        def date_range(start_date,end_date)
          start_date = Date.parse(start_date)
          end_date =  Date.parse(end_date)
          date_range = []
          (start_date .. end_date).each do |date|
            date_range << date.strftime("%Y-%m-%d")
          end
          return date_range
        end
      end
     
      resource :statis do 
        desc "统计红包浏览量、种子红包、社交红包、反馈红包",auth: { scopes: [] }
        params do
          requires :beacon_url, type: String, desc: "beacon的url" 
          requires :game_url, type: String, desc: "游戏url"
          optional :end_date, type: Date, desc: "结束时间"
          optional :start_date, type: Date, desc: "开始时间"
        end
        get "/:beacon_url/:game_url" , jbuilder: 'statis/game_statis'do
        p current_user
          @current_user = current_user.id
          p @current_user
          beacon_id = Ibeacon.get_beacon(params[:beacon_url]) 
          game_id = Material.get_game(params[:game_url])
          @name = Material.find_by_id(game_id).name
          # end_date = Date.parse(params[:end_date] || Date.today().to_s)
          # start_date = Date.parse(params[:start_date] || (end_date - 30).to_s)
          end_date = Time.now
          start_date = Time.now-24*3600*10
          date_range = date_range(start_date.to_s,end_date.to_s)
          @uv_sub_group = []
          @record_sub_group = []
          for i in 0..(date_range.length-1)
              date_range[i] = Date.parse(date_range[i])
              per_num = Uv.per_num(beacon_id,game_id,date_range[i])
              person_num = Uv.person_num(beacon_id,game_id,date_range[i])
              new_person_num = Uv.new_person_num(beacon_id,game_id,date_range[i])
              @uv_sub_group.push({"created_at" => date_range[i].to_s,"per_num" => per_num ,"person_num" => person_num,"new_person_num" => new_person_num})
              seed_redpack_num = Record.seed_redpack_num(beacon_id,game_id,date_range[i])
              social_redpack_num = Record.social_redpack_num(beacon_id,game_id,date_range[i])
              feedback_redpack_num = Record.feedback_redpack_num(beacon_id,game_id,date_range[i])
              seed_redpack = Record.seed_redpack(beacon_id,game_id,date_range[i])
              social_redpack = Record.social_redpack(beacon_id,game_id,date_range[i])
              feedback_redpack = Record.feedback_redpack(beacon_id,game_id,date_range[i])
              @record_sub_group.push({"created_at" => date_range[i].to_s,"seed_redpack_num" => seed_redpack_num,"social_redpack_num" => social_redpack_num,"feedback_redpack_num" => feedback_redpack_num,"seed_redpack" => seed_redpack,"social_redpack" => social_redpack,"feedback_redpack" => feedback_redpack})
          end
          @sum = 0
          @uv_sub_group.each{|a| @sum = @sum+a["per_num"].to_i}
          # 
          # @uv = Uv.where("created_at >= ? and created_at <= ? and game_id = ? and beaconid = ?", start_date, end_date, game_id, beacon_id)
          # @record = Record.where("created_at >= ? and created_at <= ? and game_id = ? and beaconid =? ",start_date, end_date, game_id ,beacon_id)
          # @uv_sub_group = []
          # @record_sub_group = []
          # @user = User.where("created_at >= ? and created_at <= ? ", start_date, end_date)
          # user_groups = @user.group_by{|date| date.created_at.strftime("%Y %m %d")}.as_json.each{|a| a[1].each{|a| a.select!{|key,value| key=="id"}}}
          # uv_groups = @uv.group_by{|date| date.created_at.strftime("%Y %m %d")}
          # uv_groups.each {|key,value| @uv_sub_group.push({"created_at" => key, "per_num" => value.length, "person_num" => value.as_json.each{|a| a.select!{|k,v| k =="user_id"}}.uniq.length, "new_person_num" => ((value.as_json.each{|a| a.select!{|k,v| k =="user_id"}}.uniq.map{|a|a.to_a}.flatten.delete_if{|a| a=="id"})&(user_groups[key].map{|a|a.to_a}.flatten.delete_if{|a| a=="id"})).length})}

          # record_groups = @record.group_by{|date| date.created_at.strftime("%Y %m %d")}
          # record_groups.each {|key,value| @record_sub_group.push({"created_at" => key, "seed_redpack_num" => value.as_json.select{|a| a["object_type"] == "Redpack"}.length, "social_redpack_num" => value.as_json.select{|a| a["object_type"] == "social_redpack"}.length, "feedback_redpack_num" => value.as_json.select{|a| a["object_type"] == "f_redpack"}.length, "seed_redpack" => value.as_json.select{|a| a["object_type"] == "Redpack"}.collect{|a| a["score"]}.reduce(:+), "social_redpack" => value.as_json.select{|a| a["object_type"] == "social_redpack"}.collect{|a| a["score"]}.reduce(:+), "feedback_redpack" => value.as_json.select{|a| a["object_type"] == "f_redpack"}.collect{|a| a["score"]}.reduce(:+)})}
          
        end
      end





    end

  end
end