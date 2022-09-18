require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module UrlShortnerApp
  class Application < Rails::Application
    config.load_defaults 7.0
    config.action_cable.mount_path = '/cable'
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
