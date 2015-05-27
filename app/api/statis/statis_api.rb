module API 

  module Statis

    class StatisAPI <  Grape::API 

      version 'v1'
      helpers  do
      end
     
      resource :statis do 
        desc "统计红包浏览量"
        params do
          requires :game_url,type: String, desc: "游戏url"
          optional :end_date, type: Date, desc: "结束时间"
          optional :start_date, type: Date, desc: "开始时间"
        end
        get "/:game_url" , jbuilder: 'statis/game_statis'do 
          game_id = Material.get_game(params[:game_url])
          end_date = Date.parse(params[:end_date] || Date.today().to_s)
          start_date = Date.parse(params[:start_date] || (end_date - 30).to_s)
          @uv = Uv.where("created_at >= ? and created_at <= ? and game_id = ?", start_date, end_date, game_id)
          uv_groups = @uv.group_by{|date| date.created_at.strftime("%Y %m %d")}
          @uv_sub_group = []
          uv_groups.each {|key,value| @uv_sub_group.push({"created_at" => key, "per_num" => value.length})}
          @uv_sub_group
        end
      end



    end

  end
end