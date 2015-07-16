json.result 0

json.bigbanners(@bigBanners) do |item|
  json.id item.id
  json.image_url item.image_url
  json.state item.state
  json.wait item.wait
  json.link item.link
  json.btype item.btype
end

json.banners(@banners) do |item|
  json.id item.id
  json.image_url item.image_url
  json.state item.state
  json.wait item.wait
  json.link item.link
  json.btype item.btype
end

