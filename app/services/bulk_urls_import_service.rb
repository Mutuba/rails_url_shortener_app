class BulkUrlsImportService < ApplicationService
  require 'csv'
  require 'securerandom'
  require 'faker'

  def initialize(params)
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
    batch = Batch.create!(name: "#{Faker::TvShows::GameOfThrones.house} #{SecureRandom.hex(5)}", user: @current_user)
    batch_no = SecureRandom.hex
    urls_array = []
    CSV.foreach(@file_path, headers: true) do |row|
      url_hash = Url.new

      url_hash.batch = batch
      url_hash.long_url = sanitize_url(row[0])
      url_hash.short_url = row[1].nil? ? generate_short_url : "#{@base_url}/#{row[1]}"
      url_hash.created_at = Time.now
      url_hash.updated_at = Time.now
      url_hash.user_id = @current_user.id
      urls_array << url_hash
    end

    my_proc = lambda { |_rows_size, num_batches, current_batch_number, _|
      # send an email, post to a websocket,
      # update slack, alert if import is taking too long, etc.
      # the pipe takes _rows_size, num_batches, current_batch_number, _batch_duration_in_secs
      progress = (current_batch_number * 100) / num_batches
      ActionCable.server.broadcast("#{@current_user.id}#{batch.id}",
                                   {
                                     content: progress
                                   })
    }

    instance = Url.import urls_array, batch_size: 1, batch_progress: my_proc, returning: :long_url
    failed_instances = instance.failed_instances

    failed_instances.size > 0 && failed_instances.each_slice(2).each do |array_instance|
      array_instance.each do |instance|
        FailedUrl.create(long_url: instance.long_url, batch: instance.batch, user_id: @current_user.id)
      end
    end

    success_percentage = (instance.num_inserts * 100) / (instance.num_inserts + failed_instances.size)
    batch.update(success_rate: success_percentage)
  end
end
