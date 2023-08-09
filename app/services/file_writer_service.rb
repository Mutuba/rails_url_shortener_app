# frozen_string_literal: true

# FileWriterService
class FileWriterService < ApplicationService
  def initialize(**params)
    super()
    @file = params.fetch(:file)
    @base_url = params.fetch(:base_url)
    @current_user = params.fetch(:current_user)
  end

  def call
    file_path = Rails.root.join('public', "bulk-import-#{SecureRandom.uuid}.csv")
    File.write(file_path, @file.read)
    UrlsCsvBatchUploadJob.perform_later(file_path.to_path, @base_url, @current_user)
  end
end
