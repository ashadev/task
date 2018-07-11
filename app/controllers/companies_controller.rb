class CompaniesController < ApplicationController
	before_action :set_company, only: [:edit, :update]

	def edit
	end

	def update
		@flag = current_company.update company_name: params[:company_name],
						owner_name: params[:owner_name],
						address: params[:address],
						phone_number2: params[:phone_number2],
						phone_number3: params[:phone_number3]
		if @flag
			flash[:success] = "Company updated sucessfully." 
	        redirect_to root_path
		else
			flash[:error] = "Invalid credentials, please try again." 
        	redirect_back(fallback_location: root_path)
		end
	end

	def edit_password
	end

	def update_password
		if current_company.valid_password?(params[:password])
  			if params[:re_type_password] == params[:confirmation_password]
  				current_company.password = params[:re_type_password]
  				current_company.password_confirmation = params[:confirmation_password]
  				current_company.save(validate: false)
  				bypass_sign_in(current_company)
  				flash[:success] = "Password Changed successfully"
  				redirect_to root_path
  			else
  				flash[:error] = "Re-type password and confirmation password not matched"
  				redirect_back(fallback_location: root_path)
  			end
  		else
  			flash[:error] = "Old Password is not matched"
  			redirect_back(fallback_location: root_path)
  		end
	end

	private
	def set_company
		@company = Company.find_by(id: params[:id])
		redirect_to root_path, flash: {error: "This is not valid company."}  unless @company.present?
	end
end