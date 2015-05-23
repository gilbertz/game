module API

  module MerchantInfo
    class MerchantInfoAPI < Grape::API
      version 'v1'
      helpers do
        def valid_mobile(mobile)
          mobile != nil && mobile.length >= 11
        end

        def valid_smscod(mobile, code)
          SmsSender.sms_code(mobile) == code
        end

      end
      resources :merchant do
        desc "获取手机短信验证码"
        params do
          requires :mobile, type: String, allow_blank: false, desc: "手机号"
        end
        post :smscode do
          mobile = params["mobile"]
          if valid_mobile(mobile)
            SmsSender.send_to(mobile)
            {"result" => 0}
          else
            {"result" => -1, "error_msg" => "请确定手机号码格式的正确性."}
          end


          desc "手机登录"
          params do
            requires :mobile, type: String, allow_blank: false, desc: "手机号"
            requires :code, type: String, allow_blank: false, desc: "验证码"
          end
          post :mobile_login do
            mobile = params["mobile"]
            code = params["code"]
            if valid_smscod(mobile, code)
              manager =  Manager.find_by_phone(mobile)
              if manager
                if manager.party
                  manager.party.party_sign_in
                  {"result" => 0}
                else
                  {"result" => -1, "error_msg" => "系统异常,请稍后再试."}
                end
              else

               {"result" => -1, "error_msg" => "商户不存在,请先注册成为商户."}

              end
            else
              {"result" => -1, "error_msg" => "验证码和手机号不匹配."}
            end
          end # end of post :mobile_login do



          desc "商户绑定手机号"
          params do
            requires :mobile,type: String,allow_blank: false,desc: "手机号"
            requires :code, type: String, allow_blank: false, desc: "验证码"
            optional :name, type: String, desc: "管理者的名字"
            optional :role, type: Integer, default: 1,values:[0,1,2,3], desc: "管理者的权限"
          end
          post :bind_mobile do
            if valid_smscod(params["mobile"], params["code"])
              manager =  Manager.find_by_phone(params["mobile"])
              if manager == nil
                manager = Manager.new
                manager.name = params["name"]
                manager.phone = params["mobile"]
                manager.role = params["role"]
                manager.party_id = current_user.get_party_id
                manager.save
              end
              {"result" => 0}
            else
              {"result" => -1, "error_msg" => "验证码和手机号不匹配."}
            end


          end


        end

      end


    end


  end


end
