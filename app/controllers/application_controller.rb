class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_company!, except: [:home]

  def home
  	Thread.new do
    	p 'hello...... started...'
  		Company.tcp_connection
  	end
  end
end
