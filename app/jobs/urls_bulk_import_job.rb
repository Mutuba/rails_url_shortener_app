class UrlsBulkImportJob < ApplicationJob
  include Sidekiq::Status::Worker
  self.queue_adapter = :sidekiq

  # Bulk upload urls
  def perform(file_path, base_url, current_user)
    BulkUrlsImportService.call({ file_path: file_path, base_url: base_url, current_user: current_user })
  end
end
