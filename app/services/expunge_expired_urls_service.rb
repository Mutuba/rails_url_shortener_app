# frozen_string_literal: true

# deletes expired jobs
class ExpungeExpiredUrlsService < ApplicationService
  
  def call
    # urls = Url.where('created_at <  ? ', 10.days.ago)
    Rails.logger.debug 'Expired jobs were deleted'
    urls = Url.all

    urls.each(&:delete)
  end
end
