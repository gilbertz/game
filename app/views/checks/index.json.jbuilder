json.array!(@checks) do |check|
  json.extract! check, :id, :beacondid, :user_id, :state, :lng, :lat
  json.url check_url(check, format: :json)
end
