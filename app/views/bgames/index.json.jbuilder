json.array!(@bgames) do |bgame|
  json.extract! bgame, :id, :ibeacon_id, :game_id, :state, :remark
  json.url bgame_url(bgame, format: :json)
end
