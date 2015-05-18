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

end