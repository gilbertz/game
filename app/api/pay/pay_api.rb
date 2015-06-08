require 'socket'
module API
  module Pay
    class PayAPI < Grape::API
      version 'v1'
      helpers do

        def generate_wx_pay_param(order)
          param_hash = Hash.new
          stamp = time_stamp
          str = nonce_str
          product = Product.find_by_id(order.product_id)
          param_hash["appid"]= order.appid
          param_hash["mch_id"] = order.mch_id
          param_hash["device_info"] = order.device_info
          param_hash["nonce_str"] = str
          param_hash["body"] = product.body
          param_hash["detail"] = product.detail
          param_hash["attach"] = order.attach
          param_hash["out_trade_no"] = order.out_trade_no
          param_hash["fee_type"] = order.fee_type
          param_hash["total_fee"] = order.total_fee.to_i
          param_hash["time_start"] = order.time_start
          param_hash["time_expire"] = order.time_expire
          param_hash["trade_type"] = order.trade_type
          param_hash["product_id"] = order.product_id.to_s
          param_hash["trade_type"] = order.trade_type
          param_hash["openid"] = order.openid
          if order.trade_type == "Native"
            #本机ip地址
            param_hash["spbill_create_ip"] = IPSocket.getaddress(Socket.gethostname)
          else
            #请求端的ip地址
            param_hash["spbill_create_ip"] =  request.remote_ip
          end
          param_hash["notify_url"] = "http://#{request.domain}/api/v1/pay/notify"
          param_hash["sign"] = get_sign(product.body,order.device_info,str)
          return param_hash
         end


        def

        def time_stamp
          Time.now.to_local.to_i.to_s
        end

        def nonce_str(len = 16)
          chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
          newStr = ""
          1.upto(len) { |i| newStr << chars[rand(chars.size-1)] }
          return newStr
        end

        def get_sign(body,device_info,nonce)
          stringA = "appid=#{WX_PAY_APPID}&body=#{body}&device_info=#{device_info}&mch_id=#{WX_PAY_MCHID}&nonce_str=#{nonce}"
          stringSignTemp = "#{stringA}&key=#{WX_PAY_KEY}"
          sign = Digest::MD5.hexdigest(stringSignTemp).upcase
        end
      end

      resources :pay do
        desc "支付二维码"
        params do
          requires :order_id,type:Integer,allow_blank:false,desc:"订单的ID"
        end
        post :qrcode_url do
          order = Order.find_by_id(params["order_id"])
          error! '无效订单',401 unless order
          # 如果是微信支付
          if order.pay_type == 0
            request_url = "https://api.mch.weixin.qq.com/pay/unifiedorder"
            param_hash = generate_wx_pay_param(order)
            xml_str = param_hash.to_xml_str

            uri = URI.parse(request_url)
            http = Net::HTTP.new(uri.host, uri.port)
            request = Net::HTTP::Post.new(uri)
            request.content_type = 'text/xml'
            request.body = xml_str
            response = http.start do |http|
              ret = http.request(request)
              puts request.body
              puts ret.body
            end
            {"result"=>0,"qrcode_url"=>"xxxx"}
          else
            ""
          end

        end


        desc "支付回调"
        params do
          requires
        end
        post :notify do



        end


      end




    end


  end



end