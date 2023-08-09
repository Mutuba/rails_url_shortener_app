# frozen_string_literal: true

# UrlsCsvBatchUploadJob
class UrlsCsvBatchUploadJob < ApplicationJob
  include Sidekiq::Status::Worker
  queue_as :default

  sidekiq_options lock: :until_executed,
                  on_conflict: :reject

  def perform(string_file_path, base_url, current_user)
    file_path = Rails.root.join(string_file_path)
    UrlsCsvBatchUploadService.call(file_path:, base_url:,
                                   current_user:)
  end
end
