module Yaoshengyi
  module Entities

    class CardOption < Grape::Entity
      expose :title
      expose :img
      expose :store
    end

    class Card < Grape::Entity
      expose :title
      expose :card_options, using: API::CardOption
    end
  end


  class CardAPI < Grape::API
    prefix       'api'
    version      'v1'
    format       :json

    desc "Return a card."
      params do
        requires :id, type: Integer, desc: "card id."
      end
      route_param :id do
        get do
          Card.find(params[:id])
        end
      end
    end
  end
end
