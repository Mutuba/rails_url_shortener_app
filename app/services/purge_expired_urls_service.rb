# frozen_string_literal: true

# PurgeExpiredUrlsService
class PurgeExpiredUrlsService < ApplicationService
  def call
    # Urls older than 10 days will be deleted    
    expired_urls_count = Url.where('created_at < ?', 10.days.ago).delete_all
    Rails.logger.debug "#{expired_urls_count} expired URLs were deleted" if expired_urls_count > 0
  end
end
