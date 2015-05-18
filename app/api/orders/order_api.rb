module API

  module Orders
    class OrderAPI < Grape::API

      version 'v1'

      helpers do
        def out_trade_no
          "y1y" + Time.now.strftime("yyyymmddHHMMSS")
        end
      end

      resources :order do
        desc "生成订单"
        params do
          requires :product_id,type:String,allow_blank:false,desc:"商品ID"
          requires :amount,type:Integer,allow_blank:false,desc:"购买数量"
          optional :pay_type,type:Integer,default:0,values:[0,1],desc:"支付类型,0代表微信支付,1代表支付宝支付"
          optional :attach_info,type:Hash,desc:"选择的商品附加属性"
          optional :device_info,type:String,default:"WEB",values:["WEB","JS","APP"],desc:"发起支付的方式"
        end
        post :generate do
          pay_type = params["pay_type"]
          product = Product.find_by_id(params["product_id"])
          error!('product is not find',401)  unless product
          order = Order.new
          # 微信支付
          if pay_type == 0
            order.appid = WX_PAY_APPID
            order.mch_id = WX_PAY_MCHID
          end
          order.device_info = params["device_info"]
          order.product_id = params["product_id"]
          order.out_trade_no = out_trade_no
          order.fee_type = "yuan"
          order.total_fee = (amount * product.price).to_s
          order.time_start = Time.now.strftime("yyyymmddHHMMSS")
          order.attach = params["attach_info"].to_json if params["attach_info"]
          if order.save
            {"result" => "0","order_id"=>order.id}
          else
            {"result"=> "-1"}
          end
        end




      end


    end


  end


end