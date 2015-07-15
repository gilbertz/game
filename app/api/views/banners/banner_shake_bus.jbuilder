if  @bigBanners.present?
  json.result 0
  json.banners(@bigBanners) do |item|
    json.id item.id
    json.image_url item.image_url
    json.state item.state
    json.wait item.wait
    json.link item.link
  end
  json.banners(@banners) do |item|
    json.id item.id
    json.image_url item.image_url
    json.state item.state
    json.wait item.wait
    json.link item.link
  end
else
  json.result -1
end