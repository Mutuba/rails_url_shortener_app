# frozen_string_literal: true

# BulkUrlsImportJob
class UrlsBulkImportJob < ApplicationJob
  include Sidekiq::Status::Worker
  queue_as :default
  # self.queue_adapter = :sidekiq # Todo: Fix sidekiq for heroku

  def perform(string_file_path, base_url, current_user)
    file_path = Rails.root.join(string_file_path)
    BulkUrlsImportService.call(file_path: file_path, base_url: base_url,
                               current_user: current_user)
  end
end
