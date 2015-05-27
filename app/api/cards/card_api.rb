module API

  module Cards

    # module Entities
    #   class CardOption < Grape::Entity
    #     expose :title
    #     expose :img
    #     expose :store
    #   end
    #
    #   class Card < Grape::Entity
    #     expose :title
    #     expose :card_options, using: API::CardOption
    #   end
    # end

    class CardAPI < Grape::API
      version      'v1'

      namespace :cards do

        # route_param :id do
        desc "Return a card."
        params do
          requires :id, type: Integer,allow_blank:false, desc: "card id."
        end
        route_param :id,jbuilder: 'cards/find_a_card' do
          get do
            @card = Card.find_by_id(params[:id])
          end
        end
        # route_param :id do



        #  post :create do
        desc "创建卡券"
        params do

        end
        post :create do

        end
        # post :create do



        desc "用户领取卡券"
        params do
          requires :card_id,type:Integer,allow_blank:false,desc: "卡券的ID"
        end
        get :get do
          card = Card.find_by_id(params[:card_id])
          render_api_error! "卡券不存在." unless card
          card_record = CardRecord.new
          card_record.card_id = card.id
          card_record.appid = card.appid
          card_record.event_time = Time.now
          card_record.status = 0
          card_recode.from_user_name = current_user.get_openid
          if card_record.save
            qrcode = Qrcode.new
            qrcode.ticket = SecureRandom.uuid
            qrcode.card_record_id = card_record.id
            qrcode.provide = YAOYIYAO
            qrcode.scene_type = CARD_SCENE
            qrcode.scanner = current_user.get_openid
            qrcode.url = "api/v1/cards/#{qrcode.ticket}"
            if qrcode.save
              {"result"=>0,"card" =>card,"qrcode_content" => "http://#{WX_DOMAIN}/#{qrcode.url}"}
            else
              internal_error!
            end
          else
            internal_error!
          end

        end

        # post 'verification' do
        desc "核销卡券"
        params do
          requires :card_record_id,type:Integer,allow_blank:false,desc: "卡券记录的ID"
        end
        post 'verification' do
          card_record = CardRecord.find_by_id(params["card_record_id"])
          render_api_error! "卡券不存在." unless card_record
          render_api_error! "卡券已被使用." if card_record.is_used

          card_record.set_status_used
          if card_record.save
            {"result" => 0}
          else
            internal_error!
          end
        end
        # post 'verification' do


      end

    end

  end

end