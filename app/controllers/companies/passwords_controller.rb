# frozen_string_literal: true

class Companies::PasswordsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  before_action :set_company, only: [:edit, :update]

  # GET /resource/sign_in
  def new
  end

  # POST /resource/sign_in
  def create
    @company = Company.find_by(email: params[:email])
    
    if @company.present?
      @company.send_reset_password_instructions
      redirect_to new_company_session_path
    else
      flash[:error] = "Email Id not found." 
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
  	@reset_password_token = params[:reset_password_token]
  end

  def update
  	@flag = @company.update password: params[:password], reset_password_token: nil
  	if @flag
  		flash[:success] = "Password Resetted successfully." 
  		redirect_to new_company_session_path
  	else
  		flash[:error] = "Oops! something went wrong." 
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

  private
  def set_company
  	@company = Company.with_reset_password_token(params[:reset_password_token])
  end
end
