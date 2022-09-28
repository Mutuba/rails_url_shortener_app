require 'sidekiq/web'
require 'sidekiq-status'

# Sidekiq::Web.use Rack::Auth::Basic do |username, password|
#   username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
# end

Sidekiq.configure_server do |config|
  config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end

Sidekiq.configure_client do |config|
  config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
end


Sidekiq.configure_client do |config|
    # accepts :expiration (optional)
    Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
  end
  
  Sidekiq.configure_server do |config|
    # accepts :expiration (optional)
    Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes
  
    # accepts :expiration (optional)
    Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
  end