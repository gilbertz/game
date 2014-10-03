json.array!(@wx_configs) do |wx_config|
  json.extract! wx_config, :id, :wx_ad, :wx_link, :wx_id, :secret
  json.url wx_config_url(wx_config, format: :json)
end
