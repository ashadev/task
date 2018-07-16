class VehicleTravelHistory < ApplicationRecord
	belongs_to :vehicle
	
	scope :today_history, -> (date) { where('DATE(sent_at) =?', Date.parse(date)).order('id ASC') }
	scope :ignition_on, -> { where(digital_ip_op: true)}
	scope :ignition_off, -> { where(digital_ip_op: false)}

	URL = "https://maps.googleapis.com/maps/api/geocode/json?latlng=<LATITUDE>,<LONGITUDE>&key=#{VehicleTracking::Application::GOOGLE_MAP_API_KEY}"

	def fuel_in_volts
		analog_ip2.to_s.to_f / 1000
	end

	def fuel_percentage
		return 0.0 if vehicle.get_max_volt.zero?
		return (fuel_in_volts / vehicle.get_max_volt) * 100 
		(100 - fuel_per) if vehicle.check_increase_max_volt? # for reverse volt tank logic
	end

	def is_fuel_decreased?
		if vehicle.check_increase_max_volt?
			vehicle.threshold_voltage.to_s.to_f < fuel_in_volts # for reverse logic, 7 < 5 (max volt - 0, minu volt - 10)
		else
			fuel_in_volts < vehicle.threshold_voltage.to_s.to_f
		end
	end

	def engine
		return "ON" if digital_ip_op?
		"OFF"
	end

	def vehicle_status
		return "Running" if digital_ip_op?
		"Idle"
	end

	def location
		url = URL.gsub("<LATITUDE>", latitude).gsub("<LONGITUDE>", longitude)
		result = HTTParty.get(url)
		begin
			if result.parsed_response["results"].present?
				if result.parsed_response["results"].first.present?
					result.parsed_response["results"].first["formatted_address"]
				else
					"Not able to find location"
				end
			else
				"Not able to find location"
			end
		rescue
			"Not able to find location"
		end
	end
end
