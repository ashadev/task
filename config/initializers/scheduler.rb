require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new
# eee = ErrorLog.new(error: "Cron hitted...", log_page: "Scheduler", user_id: UserLogin.first.try(:id), mobile_details: "The time is #{DateTime.now}.", created_on: DateTime.now)
# eee.save
# puts "#{eee.errors.inspect}----------------"
# p "iam hitting........"
if Rails.env.production?
	scheduler.every '1h' do
		# MessageApi.new.send_message("9597932984", "Every 30 minutes cron is running... The time is #{DateTime.now}. ")
		puts "hello..."
		Company.all.each do |company|
			company.send_last_notification
		end
	end

	scheduler.every '15m' do
		# MessageApi.new.send_message("9597932984", "Every 30 minutes cron is running... The time is #{DateTime.now}. ")
		puts "hello..."
		Company.all.each do |company|
			company.send_idle_vehicles_notification
		end
	end
end

