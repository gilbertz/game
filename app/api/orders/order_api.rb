module API

  module Orders
    class OrderAPI < Grape::API

      version 'v1'

      helpers do
        def out_trade_no
          "y1y_" + Time.now.strftime("yyyymmddHHMMSS")
        end
      end

      resources :orders do
        desc "生成订单"
        params do
          requires :product_id, type: Integer, allow_blank: false, desc: "商品ID"
          requires :amount, type: Integer, allow_blank: false, desc: "购买数量"
          optional :pay_type, type: Integer, default: 0, values: [0, 1], desc: "支付类型,0代表微信支付,1代表支付宝支付"
          optional :attach_info, type: Hash, desc: "选择的商品附加属性"
          optional :device_info, type: String, default: "WEB", values: ["WEB", "JS", "APP"], desc: "发起支付的方式"
          optional :trade_type, type: String, default: "NATIVE", values: ['JSAPI', 'NATIVE', 'APP', 'WAP'], desc: "支付的来源类型"
        end
        post :generate do
          pay_type = params["pay_type"]
          product = Product.find_by_id(params["product_id"])
          error!('product is not find', 401) unless product
          order = Order.new
          # 微信支付
          if pay_type == 0
            order.appid = WX_PAY_APPID
            order.mch_id = WX_PAY_MCHID
          else

          end
          order.device_info = params["device_info"]
          order.product_id = params["product_id"].to_s
          order.out_trade_no = out_trade_no
          order.fee_type = "CNY"
          order.total_fee = (params["amount"] * product.price).to_s
          order.time_start = Time.now.to_local.strftime("yyyyMMddHHmmss")
          order.attach = params["attach_info"].to_json if params["attach_info"]
          order.party_id = current_user.get_party_id
          order.trade_type = params["trade_type"]
          if order.trade_type == "JSAPI"
            order.openid = current_user.get_openid
          end
          order.set_wait_pay
          if order.save
            {"result" => "0", "order_id" => order.id}
          else
            {"result" => "-1"}
          end
        end

        # get :history,jbuilder: 'orders/history' do
        desc "商户的订单"
        params do
          optional :page, type: Integer, desc: "第几页"
          optional :per_page, type: Integer, default: 10, desc: "每一页的记录数"
          all_or_none_of :page, :per_page
        end
        get :history, jbuilder: 'orders/history' do
          @history = Order.where(:party_id => current_party_id)
        end
        # get :history,jbuilder: 'orders/history' do


        # get '/:id' do
        desc "某一个订单"
        get '/:id' ,jbuilder:'orders/one_order' do
          @order = Order.find_by_id_and_party_id(params["id"],current_party_id)
        end
        # get '/:id' do

        # post '/:id/update' do
        desc "更新订单"
        post '/:id/update' do

        end
        #post '/:id/update' do


        # post '/:id/delete' do
        desc "删除订单 假删"
        get '/:id/delete' do
          @order = Order.find_by_id_and_party_id(params["id"],current_party_id)
          if @order
            if @order.destroy
              {"result" => 0}
            else
              internal_error!
            end
          else
            render_api_error! "订单不存在"
          end
        end
        # post '/:id/delete' do


      end


    end


  end


end