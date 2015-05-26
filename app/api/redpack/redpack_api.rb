module API
  module RedPack
    class RedpackAPI < Grape::API
      version      'v1'

      helpers do
        def current_user
        end

        def get_beacon

        end
      end

      resources :redpack do
        desc "test_generate"
        get '/test_generate' do
          result_hongbao = Redpack.generate(params[:total].to_i, params[:count].to_i, params[:max].to_i, params[:min].to_i)
        end

        desc "test_seed_redpack"
        get '/test_seed_redpack/:redpack.id' do
          Redpack.test(params[:id])
        end

        desc "show_generate_length"
        get '/show_generate_length/:redpack.id' do
          $redis.lrange("hongbaolist_#{redpack.id}",0,-1).length
        end

        desc "show_generate"
        get '/show_generate/:id' do
          $redis.lrange("hongbaolist_#{params[:id]}",0,-1)
        end

        desc "show_consume"
        get '/show_consume/:redpack.id' do
          $redis.lrange("hongBaoConsumedList_#{redpack.id}",0,-1).length
        end

        desc "delete_redpack"
        get '/delete_redpack/:redpack.id' do
        $redis.del("hongbaolist_#{redpack.id}")
        $redis.del("hongBaoConsumedMap_#{redpack.id}")
        $redis.del("hongBaoConsumedList_#{redpack.id}")
        end

        desc "发送种子红包"
        params do
          requires :beacon_url, type: String, desc "ibeacon的id"
          requires :game_url, type: String, desc "游戏id"

        end
        get '/send_seed_redpack' do
          beacon_id = Ibeacon.get_beacon(params[:beacon_url])
          check_state = Check.find_by(user_id: current_user.id, beaconid: beaconid,state: 1,game_id: params[:game_id])
          check_num = Check.check_per_day(current_user.id,params[:game_id], beacon_id)
          if @material
           if not @material.object_type.blank? and @material.object_id
            @object = @material.object_type.capitalize.constantize.find @material.object_id
    end 
          if check_num <= 3 and check_state
            check_state.update(:state => 0) 
            info = Redpack.gain_seed_redpack(current_user.id, params[:game_id], @object, @beacon.id)
             @rp = Redpack.find(@object.id).weixin_post(current_user,params[:beaconid],info) if info >100
          render :status => 200, json: {'info' => @rp.to_i}
           else 
          render :status => 200, json: {'info' => @rp.to_i}
          end 

      end
    end
  end

end