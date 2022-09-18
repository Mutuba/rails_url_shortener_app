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
      url_hash.user_id = User.first.id
      urls_array << url_hash
    end

    my_proc = lambda { |_rows_size, num_batches, current_batch_number, _batch_duration_in_secs|
      # send an email, post to a websocket,
      # update slack, alert if import is taking too long, etc.
      p num_batches
      p current_batch_number
    }

    Url.import urls_array, batch_size: 2, batch_progress: my_proc

    # cable_ready[UserChannel].text_content(
    #   selector: '#processed-row-number-container',
    #   text: counter
    # ).broadcast_to(Current.user)

    # cable_ready['current_user'].console_log(message: 'Welcome to the site!')
    # cable_ready.broadcast
  end
end
