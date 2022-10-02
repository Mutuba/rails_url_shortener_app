# frozen_string_literal: true

# BulkUrlsImportJob
class UrlsBulkImportJob < ApplicationJob
  include Sidekiq::Status::Worker
  # self.queue_adapter = :sidekiq # Todo: should find out why sidekiq is not working on heroku

  def perform(string_file_path, base_url, current_user)
    file_path = Rails.root.join(string_file_path)
    BulkUrlsImportService.call(file_path: file_path, base_url: base_url,
                               current_user: current_user)
  end
end
