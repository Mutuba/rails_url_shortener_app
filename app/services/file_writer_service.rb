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

    UrlsCsvBatchUploadJob.perform_later(
      string_file_path: file_path.to_path,
      base_url: @base_url,
      current_user: @current_user,
    )
  rescue Errno::EACCES => e
    Rails.logger.error("Permission denied: #{e.message}")
    raise e
  rescue Errno::ENOENT => e
    Rails.logger.error("File not found: #{e.message}")
    raise e
  rescue Errno::ENOSPC => e
    Rails.logger.error("Disk full: #{e.message}")
    raise e
  rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError => e
    Rails.logger.error("Encoding error: #{e.message}")
    raise e
  rescue StandardError => e
    Rails.logger.error("IO error: #{e.message}")
    raise e
  end
end
