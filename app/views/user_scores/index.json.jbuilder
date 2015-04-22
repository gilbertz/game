json.array!(@user_scores) do |user_score|
  json.extract! user_score, :id, :user_id, :beaconid, :total_score, :state
  json.url user_score_url(user_score, format: :json)
end
