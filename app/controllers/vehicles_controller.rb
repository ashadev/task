class VehiclesController < ApplicationController
	before_action :set_vehicle, only: [:show, :list_vehicle_histories, :edit, :update, :destroy]

	def index
	end

	def new
	end

	def create
		if Vehicle.find_by(vehicle_name: params[:vehicle_name], device_id: params[:device_id]).present?
			flash[:error] = "Vehicle already present. Please try again." 
	        redirect_back(fallback_location: root_path)
	    else
			@vehicle = current_company.vehicles.new(
							vehicle_name: params[:vehicle_name],
							device_id: params[:device_id],
							vehicle_number: params[:vehicle_number],
							minimum_voltage: params[:minimum_voltage],
							maximum_voltage: params[:maximum_voltage],
							threshold_voltage: params[:threshold_voltage],
							description: params[:description],
							is_active: params[:active] || false,
							color: "%06x" % (rand * 0xffffff)
						)
			if @vehicle.save
				flash[:success] = "Vehicle created sucessfully." 
	        	redirect_to root_path
	        else
	        	flash[:error] = "Invalid credentials, please try again." 
	        	redirect_back(fallback_location: root_path)
	        end
	    end
	end

	def show
	end

	def edit
	end

	def update
		@flag = @vehicle.update(
							vehicle_number: params[:vehicle_number],
							description: params[:description],
							is_active: params[:active] || false
						)
		if @flag
			flash[:success] = "Vehicle updated sucessfully." 
	        redirect_to root_path
        else
        	flash[:error] = "Invalid credentials, please try again." 
        	redirect_back(fallback_location: root_path)
        end
	end

	def list_vehicles
		@vehicles = current_company.vehicles
	end

	def list_vehicle_histories
		@histories = @vehicle.vehicle_travel_histories.today_history(date = Vehicle::TODAY_DATE_STRFTIME)
	end

	def destroy
		@flag = @vehicle.destroy
		
		if @flag
			flash[:success] = "Vehicle deleted sucessfully." 
	        redirect_to root_path
        else
        	flash[:error] = "Something went wrong, please try again." 
        	redirect_back(fallback_location: root_path)
        end
	end

	def search
		@vehicles = current_company.vehicles.search(params[:query])
	end

	private
	def set_vehicle
		@vehicle = Vehicle.find_by(id: params[:id])
		redirect_to root_path, flash: {error: "This is not valid vehicle."}  unless @vehicle.present?
	end
end