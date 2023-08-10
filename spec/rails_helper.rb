# frozen_string_literal: true

require 'spec_helper'
require 'webdrivers'
# ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_ENV'] = 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner'
require 'devise'
require_relative 'support/capybara'
require_relative 'support/factory_bot'

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  Capybara::Selenium::Driver.new(app, profile:)
end

Capybara.default_max_wait_time = 10
Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include Warden::Test::Helpers
  config.include ActionCable::TestHelper
  config.include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test
  config.include Devise::Test::IntegrationHelpers, type: :request
  include ActiveSupport::Testing::TimeHelpers
  config.infer_spec_type_from_file_location!

  config.include Rails.application.routes.url_helpers, type: :request
  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  # start the transaction strategy as examples are run
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
