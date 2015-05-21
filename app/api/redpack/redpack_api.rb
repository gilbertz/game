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
        get '/test_seed_redpack' do
          Redpack.test(params[:id])
        end

        desc "show_generate_length"
        get '/show_generate_length' do
          $redis.lrange("hongbaolist",0,-1).length
        end

        desc "show_generate"
        get '/show_generate' do
          $redis.lrange("hongbaolist",0,-1)
        end

        get '/show_consume' do
          $redis.lrange("hongBaoConsumedList",0,-1).length
        end

        desc "delete_redpack"
        get '/delete_redpack' do
        $redis.del("hongbaolist")
        $redis.del("hongBaoConsumedMap")
        $redis.del("hongBaoConsumedList")
        end

      end
    end
  end

end