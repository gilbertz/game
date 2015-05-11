json.array!(@messages) do |message|
  json.extract! message, :id, :beaconid, :content, :start_time, :end_time, :count, :state
  json.url message_url(message, format: :json)
end
