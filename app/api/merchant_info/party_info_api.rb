module API

  module PartyInfo

    class PartyInfoAPI < Grape::API

      version 'v1'
      helpers do

      end

      # begin ====== post :party_info do
      desc "上传商户的基本信息"
      params do
        requires :name,type:String,allow_blank:false,desc:'品牌名'
        optional :logo_data,type:String,allow_blank:false,desc:'品牌logo信息'
        optional :logo_type,type:String,default:"jpg",values:["jpg","png"],desc:'logo图片的类型'
      end
      post :party_info do
        p = Partyinfo.new
        p.name = params["name"]
        p.party_id = current_user.get_party_id
        img = nil
        if params["logo_data"]
          img = Image.build(current_user.id,params["logo_data"],params["logo_type"])
          if img
            p.logo = img.photo_path
            p.state = 1
            p.title = "商户logo"
          end
        end
        if p.save
          {"result" => 0,"party_info" => p.to_json}
        else
          internal_error!
        end

      end
      #end ===== post :party_info do




      #begin post 'ibeacons/add'
      desc "添加ibeacons"
      params do
        requires :ibeacons ,type:Array do
          requires :uid,type:String,desc:"ibeacon硬件的ID"
          requires :name,type:String,desc:"ibeacon的别名"
          optional :remark,type:String,desc:"附加描述信息"
        end
      end
      post 'ibeacons/add' do
        arr = []
        ibeacon_arr = params["ibeacons"]
        ibeacon_arr.each do |item|
          ibeacon = Ibeacon.new
          ibeacon.name = item["name"]
          ibeacon.uid = item["uid"]
          ibeacon.user_id = current_user.id
          ibeacon.remark = item["remark"]
          ibeacon.state = 1
          if ibeacon.save
            arr.push ibeacon
          end

          if arr.length > 0
            {"result" => 0,"ibeacons" => arr.to_json}
          else
            internal_error!
          end

        end

      end
      #end post 'ibeacons/add'


    end

  end

end