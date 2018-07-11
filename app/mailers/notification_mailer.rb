class NotificationMailer < ApplicationMailer
	def send_hourly(company)
		@company = company

		mail(to: @company.email , subject: "Hourly Notification for #{@company.company_name}")
	end

	def send_coverage_issue(company)
		@company = company

		mail(to: @company.email , subject: "Coverage Issue Notification - #{@company.company_name}")
	end

	def send_full_tank(vehicle, company, fuel_percentage)
		@vehicle = vehicle
		@company = company
		@fuel_percentage = fuel_percentage

		mail(to: @company.email , subject: "Notification for vehicle #{@vehicle.vehicle_name} - #{@vehicle.device_id} about full tank")
	end
end
 