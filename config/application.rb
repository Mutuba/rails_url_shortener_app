require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module UrlShortnerApp
  class Application < Rails::Application
    config.load_defaults 7.0
    config.autoload_paths += %W[
      #{config.root}/app/services
    ]
    config.logger = Logger.new('log/application.log')
    # set the minimum log level
    # config.log_level = :warn

    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
