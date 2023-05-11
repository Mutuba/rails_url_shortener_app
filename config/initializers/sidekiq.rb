# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status'

Sidekiq.configure_server do |config|
  # config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'), ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }


end

Sidekiq.configure_client do |config|
  # config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }) }
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'), ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }

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
