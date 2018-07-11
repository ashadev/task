json.array! @vehicles do |vehicle|
	json.color vehicle.color
	json.vehicle_name vehicle.vehicle_name

	json.histories vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME) do |history|
	  json.lat history.latitude.to_s.to_f
	  json.lng history.longitude.to_s.to_f
	end
end