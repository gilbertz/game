
  class RedpackAPI < Grape::API
    prefix       'api'
    version      'v1'
    format       :json

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

      desc "show_generate"
      get '/show_generate' do
        $redis.lrange("hongbaolist",0,-1).length
      end
    end
  end
