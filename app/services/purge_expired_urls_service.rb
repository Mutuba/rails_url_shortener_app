# frozen_string_literal: true

# PurgeExpiredUrlsService
class PurgeExpiredUrlsService < ApplicationService
  def call
    # urls = Url.where('created_at <  ? ', 10.days.ago)
    urls = Url.all

    urls.each(&:delete)
    Rails.logger.debug 'Expired jobs were deleted'
  end
end
