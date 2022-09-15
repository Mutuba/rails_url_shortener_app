class BulkUrlsImportService < ApplicationService
  require 'csv'
  require 'securerandom'
  def initialize(params)
    @file_path = params.fetch(:file_path)
  end

  def call
    process_csv!
  end

  private

  def generate_short_url
    rand(36**8).to_s(36)
  end

  def sanitize_url(long_url_arg)
    long_url_arg.strip!
    sanitize_url = long_url_arg.downcase.gsub(%r{(https?://)|(www\.)}, '')
    "http://#{sanitize_url}"
  end

  def process_csv!
    batch_no = SecureRandom.hex

    CSV.foreach(@file_path, headers: true) do |row|
      url_hash = Url.new

      url_hash.batch_no = batch_no
      url_hash.long_url = sanitize_url(row[0])
      url_hash.short_url = row[1].nil? ? generate_short_url : row[1]
      url_hash.created_at = Time.now
      url_hash.updated_at = Time.now
      url_hash.save!
    end
  end
end
