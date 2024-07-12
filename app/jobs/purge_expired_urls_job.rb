# frozen_string_literal: true

# Removes expired urls in the background
# "every day at five" # => '0 5 * * *'
# "every 3 hours"     # => '0 */3 * * *'
# Sidekiq::Cron::Job.create(name: 'Hard worker - every 5min',
# cron: '*/5 * * * *', class: 'HardWorker')
# execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
require 'sidekiq-scheduler'
require 'sidekiq-status'
# calls PurgeExpiredUrlsService
class PurgeExpiredUrlsJob < ApplicationJob
  queue_as :purge_expired_urls
  sidekiq_options retry: false

  def perform
    logger.info "PurgeExpiredUrlsJob running"
    PurgeExpiredUrlsService.call
    logger.info "PurgeExpiredUrlsJob finished "
  end
end
