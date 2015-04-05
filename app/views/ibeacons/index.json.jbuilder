json.array!(@ibeacons) do |ibeacon|
  json.extract! ibeacon, :id, :name, :user_id, :state, :remark, :url
  json.url ibeacon_url(ibeacon, format: :json)
end
