json.array!(@flinks) do |flink|
  json.extract! flink, :id, :beaconid, :wxid, :wxurl, :state
  json.url flink_url(flink, format: :json)
end
