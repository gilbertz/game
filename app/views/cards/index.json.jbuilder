json.array!(@cards) do |card|
  json.extract! card, :id, :beaconid, :shop_id, :appid, :cardid
  json.url card_url(card, format: :json)
end
