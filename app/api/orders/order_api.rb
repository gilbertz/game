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
          requires :product_id,type:Integer,allow_blank:false,desc:"商品ID"
          requires :amount,type:Integer,allow_blank:false,desc:"购买数量"
          optional :pay_type,type:Integer,default:0,values:[0,1],desc:"支付类型,0代表微信支付,1代表支付宝支付"
          optional :attach_info,type:Hash,desc:"选择的商品附加属性"
          optional :device_info,type:String,default:"WEB",values:["WEB","JS","APP"],desc:"发起支付的方式"
          optional :trade_type,type:String,default:"NATIVE",values:['JSAPI','NATIVE','APP','WAP'],desc:"支付的来源类型"
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
          order.product_id = params["product_id"].to_s
          order.out_trade_no = out_trade_no
          order.fee_type = "CNY"
          order.total_fee = (amount * product.price).to_s
          order.time_start = Time.now.to_local.strftime("yyyyMMddHHmmss")
          order.attach = params["attach_info"].to_json if params["attach_info"]
          order.party_id = current_user.get_party_id
          order.trade_type = params["trade_type"]
          if order.trade_type == "JSAPI"
            order.openid = current_user.get_openid
          end
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