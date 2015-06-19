if  @choice.present?
  json.result 0
  json.choice do
    json.id @choice.id
    json.image_url @choice.image_url
    json.state @choice.state
    json.link @choice.link
  end
else
  json.result -1
end