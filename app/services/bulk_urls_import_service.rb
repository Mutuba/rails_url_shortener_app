# frozen_string_literal: true

# handles the bulk upload process

class BulkUrlsImportService < ApplicationService
  require 'csv'

  def initialize(params)
    super()
    @file_path = params.fetch(:file_path)
    @base_url = params.fetch(:base_url)
    @current_user = params.fetch(:current_user)
  end

  def call
    process_csv!
  end

  private

  def generate_short_url
    "#{@base_url}/#{SecureRandom.hex(4)}"
  end

  def sanitize_url(long_url_arg)
    long_url_arg.strip.downcase.sub(%r{(https?://)|(www\.)}, 'http://')
  end

  def create_batch
    Batch.create(
      name: "#{Faker::TvShows::GameOfThrones.house} #{SecureRandom.hex(5)}",
      user: @current_user
    )
  end

  def process_csv!
    batch = create_batch
    urls_array = []
  
    begin
      CSV.foreach(@file_path, headers: true) do |row|
        url_hash = Url.new
  
        url_hash.batch = batch
        url_hash.long_url = sanitize_url(row[0])
        url_hash.short_url = row[1].nil? ? generate_short_url : "#{@base_url}/#{row[1]}"
        url_hash.created_at = Time.zone.now
        url_hash.updated_at = Time.zone.now
        url_hash.user_id = @current_user.id
  
        urls_array << url_hash
      end
    rescue Errno::ENOENT, Errno::EACCES, CSV::MalformedCSVError => e
      Rails.logger.info e.message
    ensure
      File.delete(@file_path) if File.exist?(@file_path)
    end
  
    instance = import_urls(urls_array, batch)
    record_failed_urls(instance.failed_instances)
    record_batch_metrics(instance, batch)
  end
    
  def import_urls(urls_array, batch)
    my_proc = lambda { |_, num_batches, current_batch_number, _|
      progress = (current_batch_number * 100) / num_batches
      ActionCable.server.broadcast("#{@current_user.id}#{batch.id}", { content: progress })
    }

    Url.import urls_array, batch_size: 2, batch_progress: my_proc
  end

  def record_failed_urls(failed_instances)
    return unless failed_instances.size.positive?

    failed_instances.each_slice(2) do |array_instance|
      array_instance.each do |element|
        FailedUrl.create(long_url: element.long_url, batch: element.batch, user_id: @current_user.id)
      end
    end
  end

  def record_batch_metrics(instance, batch)
    total_request_load = instance&.num_inserts + instance&.failed_instances.size
    success_percentage = (instance&.num_inserts * 100) / total_request_load
    batch.update(success_rate: success_percentage)
  end
end
