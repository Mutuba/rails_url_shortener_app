# frozen_string_literal: true

require 'sidekiq-scheduler'
# HelloWorldWorker
class HelloWorldWorker
  include Sidekiq::Worker
  queue_as :hello_world

  sidekiq_options retry: false

  def perform
    logger.info 'Hello world!'
  end
end
