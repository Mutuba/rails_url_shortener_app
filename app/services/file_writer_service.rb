# frozen_string_literal: true

# FileWriterService
class FileWriterService < ApplicationService
  def initialize(**params)
    super()
    @file_path = params.fetch(:file_path)
    @base_url = params.fetch(:base_url)
    @current_user = params.fetch(:current_user)
  end

  def perform
    file_path = Rails.root.join('public', "bulk-import-#{SecureRandom.uuid}.csv")
    File.write(file_path, @file.read)
    UrlsCsvBatchUploadJob.perform_later(file_path.to_path, @base_url, @current_user)
  end
end
