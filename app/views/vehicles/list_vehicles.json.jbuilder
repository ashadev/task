# json.array! @vehicles do |vehicle|
# 	json.color vehicle.color
# 	json.vehicle_name vehicle.vehicle_name

# 	json.histories vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME) do |history|
# 	  json.lat history.latitude.to_s.to_f
# 	  json.lng history.longitude.to_s.to_f
# 	end
# end

json.array! @vehicles do |vehicle|
	json.color vehicle.color
	json.vehicle_name vehicle.vehicle_name
	json.device_id vehicle.device_id
	json.last_updated_time vehicle.last_updated_time
		if vehicle.check_last_history?
			json.histories do
				json.lat vehicle.last_latitude
				json.lng vehicle.last_longitude
			
			end
		end
end