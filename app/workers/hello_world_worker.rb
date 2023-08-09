# frozen_string_literal: true

require 'sidekiq-scheduler'
# HelloWorldWorker
class HelloWorldWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: false

  def perform
    # puts 'Hello world!'
  end
end
