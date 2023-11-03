# frozen_string_literal: true

# UrlsCsvBatchUploadJob
class UrlsCsvBatchUploadJob < ApplicationJob
  include Sidekiq::Status::Worker
  queue_as :default

  sidekiq_options lock: :until_executed,
                  on_conflict: :reject

  def perform(**params)
    string_file_path = params.fetch(:string_file_path)
    base_url = params.fetch(:base_url)
    current_user = params.fetch(:current_user)

    begin
      file_path = Rails.root.join(string_file_path)
      UrlsCsvBatchUploadService.call(file_path:, base_url:,
                                     current_user:)
    rescue StandardError => e
      
      Rails.logger.error("An error occurred: #{e.message}")
    end
  end
end
