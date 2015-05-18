module API
  module Pay
    class PayAPI < Grape::API
      version 'v1'
      helpers do

      end

      resources :pay do
        desc "支付二维码"
        params do
          requires :order_id,type:Integer,allow_blank:false,desc:"订单的ID"
        end
        post :qrcode do
          error! '无效订单',401 unless params["order_id"]


        end

      end




    end


  end



end