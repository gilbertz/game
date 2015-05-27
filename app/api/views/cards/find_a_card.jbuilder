if @card
  json.result 0
  json.card @card
else
  internal_error!
end