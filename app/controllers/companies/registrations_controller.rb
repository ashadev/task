# frozen_string_literal: true

class Companies::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if Company.find_by(email: params[:email]).present?
      flash[:error] = "Email Id already exist, please try again."
      redirect_back(fallback_location: root_path)
    else
      if params[:password] == params[:confirm_password]
        @company = Company.new
        @company.email = params[:email]
        @company.password = params[:password]
        @company.company_name = params[:company_name]
        @company.owner_name = params[:owner_name]
        @company.address = params[:address]
        @company.phone_number = params[:phone_number]
        @company.phone_number2 = params[:phone_number2]
        @company.phone_number3 = params[:phone_number3]
        # @company.token = SecureRandom.uuid
        if @company.save
          flash[:success] = "Successfully registered."
          sign_in(:company, @company)
          redirect_to root_path
        else
          flash[:error] = "Invalid credentials, please try again."
          redirect_back(fallback_location: root_path)
        end
      else
        flash[:error] = "Password and Confirm Password do not match"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
