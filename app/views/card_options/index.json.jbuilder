json.array!(@card_options) do |card_option|
  json.extract! card_option, :id, :value, :store, :title, :img, :wx_cardid, :desc, :probability
  json.url card_option_url(card_option, format: :json)
end
