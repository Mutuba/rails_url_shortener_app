# frozen_string_literal: true

# handles the bulk upload process
class BulkUrlsImportService < ApplicationService
  require 'csv'
  require 'securerandom'
  require 'faker'

  def initialize(params)
    super
    @file_path = params.fetch(:file_path)
    @base_url = params.fetch(:base_url)
    @current_user = params.fetch(:current_user)
  end

  def call
    process_csv!
  end

  private

  def generate_short_url
    "#{@base_url}/#{rand(36**8).to_s(36)}"
  end

  def sanitize_url(long_url_arg)
    long_url_arg.strip!
    sanitize_url = long_url_arg.downcase.gsub(%r{(https?://)|(www\.)}, '')
    "http://#{sanitize_url}"
  end

  def process_csv!
    batch = Batch.create!(
      name: "#{Faker::TvShows::GameOfThrones.house} #{SecureRandom.hex(5)}",
      user: @current_user,
    )
    urls_array = []
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

    my_proc = lambda { |_, num_batches, current_batch_number, _|
      # send an email, post to a websocket,
      # update slack, alert if import is taking too long, etc.
      # the pipe takes _rows_size, num_batches, current_batch_number, _batch_duration_in_secs
      progress = (current_batch_number * 100) / num_batches
      ActionCable.server.broadcast("#{@current_user.id}#{batch.id}",
                                   {
                                     content: progress,
                                   })
    }

    instance = Url.import urls_array, batch_size: 1, batch_progress: my_proc,
                                      returning: :long_url
    failed_instances = instance.failed_instances

    failed_instances.size.positive? && failed_instances.each_slice(2).each do |array_instance|
      array_instance.each do |element|
        FailedUrl.create(long_url: element.long_url, batch: element.batch,
                         user_id: @current_user.id)
      end
    end

    total_request_load = instance.num_inserts + failed_instances.size
    success_percentage = (instance.num_inserts * 100) / total_request_load
    batch.update(success_rate: success_percentage)
  end
end
