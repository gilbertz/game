module CUSTOMER

  module  HeadlineInfo

    class HeadlineAPI < Grape::API
      version 'v1'

      helpers do
        
      end

      resource :headline do 
        desc "头条游戏"
        params do 
          requires :name, type: String, allow_blank: false, desc: '姓名'
          requires :city, type: String, allow_blank: false, desc: '地区'
          requires :gender, type: String, allow_blank: false, desc: '男女'
          requires :teacher, type: String, allow_blank: false, desc: '导师'
        end
        get do
          content = Headline.where(teacher: params[:teacher]).sample.content
          content.gsub!("name","#{params[:name]}")
          content.gsub!("city","#{params[:city]}")
          content.gsub!("gender","#{params[:gender]}")
          if params[:gender] == "男孩"
            pronoun = "他"
          elsif params[:gender] == "女孩"
            pronoun = "她"
          end  
          content.gsub!("pronoun", pronoun)
          return {'result' => 0, 'content' => content}
        end
      end

    end
  end
end