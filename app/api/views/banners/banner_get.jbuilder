json.result 0
json.banners(@banners) do |item|
  json.id item.id
  json.image_url item.image_url
  json.state item.state
  json.wait item.wait
  json.link item.link
end

