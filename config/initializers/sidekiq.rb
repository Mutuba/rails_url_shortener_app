# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status'
# require 'sidekiq-unique-jobs'

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }

  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
  config.client_middleware do |chain|
    # chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }

  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i

  config.client_middleware do |chain|
    # chain.add SidekiqUniqueJobs::Middleware::Client
  end

  # config.server_middleware do |chain|
  #   chain.add SidekiqUniqueJobs::Middleware::Server
  # end

  # SidekiqUniqueJobs::Server.configure(config)
end
