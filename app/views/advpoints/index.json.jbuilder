json.array!(@advpoints) do |advpoint|
  json.extract! advpoint, :id, :company, :province, :city, :address, :advtype, :mark,:trans_desc,:facility_desc,:people_flow, :party_id
  json.url advpoint_url(advpoint, format: :json)
end
