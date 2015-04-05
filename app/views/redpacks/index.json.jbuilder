json.array!(@redpacks) do |redpack|
  json.extract! redpack, :id, :beaconid, :app_id, :shop_id, :sender_name, :wishing, :action_title, :action_remark, :min, :max, :suc_url, :fail_url
  json.url redpack_url(redpack, format: :json)
end
