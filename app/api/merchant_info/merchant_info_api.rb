module API

  module MerchantInfo
    class MerchantInfoAPI < Grape::API
      version 'v1'
      helpers do
        def valid_mobile(mobile)
          mobile != nil && mobile.length >= 11
        end


      end
      resources :merchant do
        desc "获取手机短信验证码"
        params do
          requires :mobile,type:String,allow_blank:false,desc:"手机号"
        end
        post :smscode do
          mobile = params["mobile"]
          error_msg = ""
          if valid_mobile(mobile)
            SmsSender.send_to(mobile)
            {"result"=> 0}
          else
            {"result"=> -1,"error_msg"=>"请确定手机号码格式的正确性."}
          end


        end

      end


    end


  end


end