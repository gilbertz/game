module API

  module PartyInfo

    class PartyInfoAPI < Grape::API

      version 'v1'
      helpers do

      end

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

    end

  end

end