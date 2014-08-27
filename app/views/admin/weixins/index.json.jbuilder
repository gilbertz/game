json.array!(@weixins) do |weixin|
  json.extract! weixin, :id, :wxid, :active, :tid
  json.url weixin_url(weixin, format: :json)
end
