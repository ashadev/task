json.array! @histories do |history|
  json.lat history.latitude.to_s.to_f
  json.lng history.longitude.to_s.to_f
end