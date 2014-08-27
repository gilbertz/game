json.array!(@domains) do |domain|
  json.extract! domain, :id, :name, :active, :tid
  json.url domain_url(domain, format: :json)
end
