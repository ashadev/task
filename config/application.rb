require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VehicleTracking
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Kolkata'
    config.active_record.default_timezone = :local
    LOCAL_HOST_URL = "http://localhost:3000"
    GOOGLE_MAP_API_KEY = "AIzaSyCmG3jBad2HLmPLgcTDLqH55a3aCEQ7ZQk"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

 #    config.after_initialize do
	#     Thread.new do
	#     p 'hello...... started...'
	#   		Company.tcp_connection
	#   	end
	# end
  end
end
