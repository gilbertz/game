json.array!(@burls) do |burl|
  json.extract! burl, :id, :url, :beaconid, :weight, :state, :pv, :uv, :title, :img, :remark
  json.url burl_url(burl, format: :json)
end
