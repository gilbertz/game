json.array!(@scores) do |score|
  json.extract! score, :id, :user_id, :beaconid, :value, :from_user_id, :remark
  json.url score_url(score, format: :json)
end
