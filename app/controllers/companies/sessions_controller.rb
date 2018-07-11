# frozen_string_literal: true

class Companies::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
  end

  # POST /resource/sign_in
  def create
    @company = Company.find_by(email: params[:email])
    
    if @company.present?
      if @company.valid_password?(params[:password])
        sign_in(:company, @company)
        redirect_to root_path
      else
        flash[:error] = "Invalid Password." 
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:error] = "Invalid Email Id." 
      redirect_back(fallback_location: root_path)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
