module API
  module RedPack
    class RedpackAPI < Grape::API
      version      'v1'

      helpers do
        def current_user
        end
      end

      resource :redpack do
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
        get '/show_generate/:redpack.id' do
          $redis.lrange("hongbaolist_#{redpack.id}",0,-1)
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

      end
    end
  end

end