json.result 0
if  @activity_appearance.present?
  json.appearance @activity_appearance
end

if  @component_appearance.present?
  json.appearance @component_appearance
end