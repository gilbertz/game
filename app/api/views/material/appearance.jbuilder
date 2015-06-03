if @object.present?
  json.result 0
  json.object @object
else
  render_api_error! '非法应用!'
end