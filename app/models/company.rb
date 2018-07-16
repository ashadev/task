class Company < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    has_many :vehicles, dependent: :destroy

    def self.tcp_connection
    	p 'inside function'
    	require 'socket' # Sockets are in standard library

		server = TCPServer.new('192.168.1.114', '6789')
		begin
		    while connection = server.accept
		        while line = connection.gets
		            puts line

		        	valid_line = line.split("@@")[-1]
		        	spliting_line = valid_line.split(',')
		        	incom_device_id = spliting_line[0]
		        	vehicle = Vehicle.find_by(device_id: incom_device_id)
		        	p "#{vehicle.inspect}--------vehicle"
		        	if vehicle.present?
		        		p "Vehicle Present"
		        		# @@863071010318308,,,070739,1100.7798,N,07657.7126,E,0.43,210813,A,1100,1,0,02700,05800,#
		        		# 864502036320950,,0,004529,,,,,0.00,060180,N,0000,0,0,02968,00000,#
		        		# 864502036320950,,0,001851,,,,,0.00,060180,N,0000,1,0,14079,00033,#
		        		
		        		dummy_val = spliting_line[1]
		        		p "#{dummy_val}-----part2"
		        		dum_val = spliting_line[2]
		        		p "#{dum_val}-----part3"
		        		utc_time = spliting_line[3]
		        		p "#{utc_time}-----part4---utctime"
		        		incom_lat = spliting_line[4]
		        		incom_lat_pole = spliting_line[5]
		        		p "#{incom_lat_pole}----incom_lat_pole"
		        		incom_long = spliting_line[6]
		        		incom_long_pole = spliting_line[7]
		        		p "#{incom_long_pole}------incom_long_pole"
		        		incom_speed = spliting_line[8]
		        		p "#{incom_speed}------incom_speed"
		        		incom_date = spliting_line[9]
		        		p "#{incom_date}------incom_date"
		        		status = spliting_line[10]
		        		p "#{status}------status"
		        		incom_dig_ip_op = spliting_line[11]
		        		p "#{incom_dig_ip_op}------incom_dig_ip_op"
		        		p "#{incom_dig_ip_op.to_s[0]}------incom_dig_ip_op.to_s[0]"
		        		ext_power_supply = spliting_line[12]
		        		p "#{ext_power_supply}------ext_power_supply"
		        		reserved = spliting_line[13]
		        		analog_ip1 = spliting_line[14]
		        		p "#{analog_ip1}------analog_ip1"
		        		analog_ip2 = spliting_line[15]
		        		p "#{analog_ip2}------analog_ip2"
		        		history = vehicle.vehicle_travel_histories.new(
		        			latitude: Company.lat_log_cal(incom_lat, incom_lat_pole),
		        			longitude: Company.lat_log_cal(incom_long, incom_long_pole),
		        			speed: Company.speed_cal(incom_speed),
		        			digital_ip_op: incom_dig_ip_op.to_s[0],
		        			external_power_status: ext_power_supply,
		        			analog_ip1: analog_ip1,
		        			analog_ip2: analog_ip2,
		        			sent_at: Company.datetime_parse(incom_date, utc_time)
		        		)
		        		history.save
		        		p "Data saved..."
		        		
		        	else
		        		p "Vehicle Not present...."
		        	end


		        end
		      #connection.close
		      # server.close
		    end
		rescue Errno::ECONNRESET, Errno::EPIPE => e
		    puts e.message
		    retry
		end
    end

    def self.lat_log_cal(lat_log, lat_log_pole)
    	p "inside lat_log_cal"
    	clean_lat_log = lat_log.to_f.to_s
    	f_lat_log = clean_lat_log.slice(0..1).to_f
    	l_lat_log = clean_lat_log.slice(2..-1).to_f
    	f_lat_log + (l_lat_log / 60)
    end

    def self.speed_cal(incom_speed)
    	incom_speed.to_f * 1.852
    end

    def self.datetime_parse(date, time)
    	DateTime.strptime("#{date} #{time}", '%d%m%y %H%M%S')
    end

	# def last_latitude
	# 	return 10.993442.to_s.to_f unless self.vehicles.present?

 #    	self.vehicles.each_with_index do |vehicle, index|
 #    		return 10.993442.to_s.to_f unless vehicle.present?
 #    		today_histories = vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME)
 #    		if index == -1
 #    			return 10.993442.to_s.to_f unless today_histories.present?

 #    			last_rec = today_histories.last
	# 			lat = last_rec.present? ? last_rec.latitude.to_s.to_f : 10.993442.to_s.to_f
	# 			return lat.zero? ? 10.993442.to_s.to_f : lat
 #    		else
	#     		next unless today_histories.present?
	    		
	#     		last_rec = today_histories.last
	# 			lat = last_rec.present? ? last_rec.latitude.to_s.to_f : 10.993442.to_s.to_f
	# 			return lat.zero? ? 10.993442.to_s.to_f : lat
 #    		end
 #    	end
	# end


	def last_latitude
		return 10.993442.to_s.to_f unless self.vehicles.present?
		self.vehicles.each_with_index do |vehicle, index|
			if index == (self.vehicles.count - 1)
				histories = vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME).pluck(:latitude)
				histories.delete("0.0")
				return 10.993442.to_s.to_f unless histories.present?
				return histories[0]
			else
				histories = vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME).pluck(:latitude)
				histories.delete("0.0")
				next unless histories.present?
				return histories[0]
			end
		end
	end

	def last_longitude
		return 77.56.to_s.to_f unless self.vehicles.present?
		self.vehicles.each_with_index do |vehicle, index|
			if index == (self.vehicles.count - 1)
				histories = vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME).pluck(:longitude)
				histories.delete("0.0")
				return 77.56.to_s.to_f unless histories.present?
				return histories[0]
			else
				histories = vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME).pluck(:longitude)
				histories.delete("0.0")
				next unless histories.present?
				return histories[0]
			end
		end
	end

	# def last_longitude
	# 	return 77.56.to_s.to_f unless self.vehicles.present?

 #    	self.vehicles.each_with_index do |vehicle, index|
 #    		return 77.56.to_s.to_f unless vehicle.present?
 #    		today_histories = vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME)
 #    		if index == -1
 #    			return 77.56.to_s.to_f unless today_histories.present?

 #    			last_rec = today_histories.last
	# 			long =  last_rec.present? ? last_rec.longitude.to_s.to_f : 77.56.to_s.to_f
	# 			return long.zero? ? 77.56.to_s.to_f : long
 #    		else
	#     		next unless vehicle.vehicle_travel_histories.present?
	    		
	#     		last_rec = today_histories.last
	# 			long =  last_rec.present? ? last_rec.longitude.to_s.to_f : 77.56.to_s.to_f
	# 			return long.zero? ? 77.56.to_s.to_f : long
	# 		end
 #    	end
	# end

	def send_last_notification
		NotificationMailer.send_hourly(self).deliver_now
	end

	def get_all_vehicle_15_mins_out_of_coverage(array = [])
		vehicles.each do |vehicle|
			array << vehicle.idle_for_15_mins.present?
		end

		return array
	end

	def is_any_vehicle_15_mins_out_of_coverage?
		return false unless get_all_vehicle_15_mins_out_of_coverage.present?
		get_all_vehicle_15_mins_out_of_coverage.include?(false)
	end

	def send_idle_vehicles_notification
		return unless is_any_vehicle_15_mins_out_of_coverage?
		NotificationMailer.send_coverage_issue(self).deliver_now
	end
end
