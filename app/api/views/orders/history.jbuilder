json.result 0
json.orders(@history) do |item|
  json.id item.id
  json.status item.status
  json.updated_at item.updated_at
end