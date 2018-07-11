class Vehicle < ApplicationRecord
	belongs_to :company
	has_many :vehicle_travel_histories, dependent: :destroy

	scope :active, -> { where(is_active: true) }
	scope :inactive, -> { where(is_active: false) }

	TODAY_DATE_STRFTIME = Date.today.strftime("%d/%m/%Y")

	validates :vehicle_name, :device_id, :minimum_voltage, :maximum_voltage, :threshold_voltage, presence: true

	# All the distances are in KM only
	def last_30_mins_distance_traveled(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour  
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 30.minutes).strftime("%H:%M:%S")

		speeds = vehicle_travel_histories.today_history(date).where("TIME(created_at) BETWEEN '#{from_time}' AND '#{to_time}'").pluck(:speed)

		return 0 if speeds.count.zero?
		avg_speed = (speeds.map(&:to_f).inject(0, :+).to_s.to_f / speeds.count)

		(avg_speed * (30 * 0.0166667)).round(3)
	end

	def last_60_mins_distance_traveled(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour 
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 1.hour).strftime("%H:%M:%S")

		speeds = vehicle_travel_histories.today_history(date).where("TIME(created_at) BETWEEN '#{from_time}' AND '#{to_time}'").pluck(:speed)
		return 0 if speeds.count.zero?
		avg_speed = (speeds.map(&:to_f).inject(0, :+).to_s.to_f / speeds.count)

		(avg_speed * 1).round(3)
	end

	def last_90_mins_distance_traveled(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour 
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - (1.hour + 30.minutes)).strftime("%H:%M:%S")

		speeds = vehicle_travel_histories.today_history(date).where("TIME(created_at) BETWEEN '#{from_time}' AND '#{to_time}'").pluck(:speed)
		return 0 if speeds.count.zero?
		avg_speed = (speeds.map(&:to_f).inject(0, :+).to_s.to_f / speeds.count)

		(avg_speed * (90 * 0.0166667)).round(3)
	end

	def last_120_mins_distance_traveled(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour 
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 2.hour).strftime("%H:%M:%S")

		speeds = vehicle_travel_histories.today_history(date).where("TIME(created_at) BETWEEN '#{from_time}' AND '#{to_time}'").pluck(:speed)
		return 0 if speeds.count.zero?
		avg_speed = (speeds.map(&:to_f).inject(0, :+).to_s.to_f / speeds.count)

		(avg_speed * 2).round(3)
	end


	# ============ Fuel Level ===================

	def avg_fuel_level(date, from_time, to_time)
		analog_ips = vehicle_travel_histories.today_history(date).where("TIME(created_at) BETWEEN '#{from_time}' AND '#{to_time}'").pluck(:analog_ip2)
		return 0 if analog_ips.count.zero?
		(analog_ips.map(&:to_f).inject(0, :+).to_s.to_f / analog_ips.count).round(3)
	end
	
	def last_30_mins_fuel_Level(date = TODAY_DATE_STRFTIME)
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 30.minutes).strftime("%H:%M:%S")

		avg_fuel_level(date, from_time, to_time)
	end

	def last_60_mins_fuel_Level(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour 
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 1.hour).strftime("%H:%M:%S")

		avg_fuel_level(date, from_time, to_time)
	end

	def last_90_mins_fuel_level(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour 
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - (1.hour + 30.minutes)).strftime("%H:%M:%S")

		avg_fuel_level(date, from_time, to_time)
	end

	def last_120_mins_fuel_level(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour 
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 2.hour).strftime("%H:%M:%S")
		
		avg_fuel_level(date, from_time, to_time)
	end

	def last_updated_time
		last_rec = vehicle_travel_histories.last
		
		last_rec.created_at.strftime("%I:%M %p") if last_rec.present?
	end

	def last_latitude
		today_histories = vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME)
		return 10.993442.to_s.to_f unless today_histories.present?
		today_histories.each_with_index do |histroy, index|
			if index == (today_histories.count - 1)
				return 10.993442.to_s.to_f if histroy.latitude.to_s.to_f.zero?
				return histroy.latitude.to_s.to_f
			else
				next if histroy.latitude.to_s.to_f.zero?
				return histroy.latitude.to_s.to_f
			end
		end
	end

	def last_longitude
		today_histories = vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME)
		return 77.56.to_s.to_f unless today_histories.present?
		today_histories.each_with_index do |histroy, index|
			if index == (today_histories.count - 1)
				return 77.56.to_s.to_f if histroy.longitude.to_s.to_f.zero?
				return histroy.longitude.to_s.to_f
			else
				next if histroy.longitude.to_s.to_f.zero?
				return histroy.longitude.to_s.to_f
			end
		end
	end

	def get_max_volt
		check_increase_max_volt? ? minimum_voltage.to_s.to_f : maximum_voltage.to_s.to_f
	end

	def check_increase_max_volt?
		maximum_voltage.to_s.to_f.zero?
	end

	def send_full_fuel_notification(histroy)
		return unless histroy.present?
		return unless histroy.kind_of?(VehicleTravelHistory)
		NotificationMailer.send_full_tank(self, self.company, histroy.fuel_percentage).deliver_now
	end

	def idle_for_15_mins(date = TODAY_DATE_STRFTIME)
		# 1 min * 0.0166667 => hour  
		to_time = Time.now.strftime("%H:%M:%S")
		parse_to_time = Time.parse(to_time)
		from_time = (parse_to_time - 15.minutes).strftime("%H:%M:%S")

		vehicle_travel_histories.where("TIME(created_at) BETWEEN '#{from_time}' AND '#{to_time}'").today_history(date)
	end

	def self.search(word)
		Vehicle.where("vehicle_name like ? or device_id like ?","%#{word}%", "%#{word}%")
	end
end
