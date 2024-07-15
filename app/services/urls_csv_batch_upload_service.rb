# frozen_string_literal: true

class UrlsCsvBatchUploadService < ApplicationService
  require 'csv'

  def initialize(**params)
    super()
    @file_path = params.fetch(:file_path)
    @base_url = params.fetch(:base_url)
    @current_user = params.fetch(:current_user)
  end

  def call
    process_csv!
  end

  private

  def process_csv!
    batch = create_batch
    urls_array = []
    url_tag_associations = []

    begin
      CSV.foreach(@file_path, headers: true) do |row|
        url_hash = process_url_hash(row, batch)
        urls_array << url_hash
        tag_names = row['tags']&.split(',')&.map(&:strip)&.reject(&:blank?)
        url_tag_associations << { url_hash: url_hash, tag_names: tag_names } if tag_names
      end
    rescue Errno::ENOENT, Errno::EACCES, CSV::MalformedCSVError => e
      logger.info e.message
      raise
    ensure
      File.delete(@file_path) unless Rails.env.test?
    end

    instance = import_urls(urls_array, batch)
    record_failed_urls(instance&.failed_instances)
    associate_tags_with_urls(url_tag_associations) # url_tag_associations[:url_hash] is an actual active record object
    record_batch_metrics(instance, batch)
  end

  def process_url_hash(row, batch)
    Url.new(
      batch: batch,
      long_url: row[0],
      short_url: row[1].nil? ? generate_short_url : "#{@base_url}/#{row[1]}",
      created_at: Time.zone.now,
      updated_at: Time.zone.now,
      user_id: @current_user.id
    )
  end

  def create_batch
    Batch.create!(
      name: "#{Faker::TvShows::GameOfThrones.house} #{SecureRandom.hex(5)}",
      user: @current_user,
    )
  end

  def generate_short_url
    "#{@base_url}/#{SecureRandom.hex(4)}"
  end

  def import_urls(urls_array, batch)
    progress = lambda { |_, num_batches, current_batch_number, _|
      progress = (current_batch_number * 100) / num_batches
      ActionCable.server.broadcast("user_#{@current_user.id}_batch_#{batch.id}", { content: progress })
    }
    Url.import urls_array, batch_size: 2, batch_progress: progress, returning: :id
  end

  def associate_tags_with_urls(url_tag_associations)
    url_tag_associations.each do |url_tag_association|
      url = url_tag_association[:url_hash]
      create_tags(url, url_tag_association[:tag_names])
    end
  end

  def create_tags(url, tag_names)
    tag_names.each do |tag_name|
      url.tags.find_or_create_by(name: tag_name.downcase)
    end
  end

  def record_failed_urls(failed_instances)
    return unless failed_instances&.size&.positive?

    failed_instances.each_slice(2) do |array_instance|
      array_instance.each do |element|
        FailedUrl.create(long_url: element&.long_url, batch: element&.batch,
                         user_id: @current_user&.id)
      end
    end
  end

  def record_batch_metrics(instance, batch)
    total_inserts = instance&.num_inserts || 0
    total_failed = instance&.failed_instances&.size || 0

    total_request_load = total_inserts + total_failed
    success_percentage = (total_inserts.to_f / total_request_load) * 100

    batch.update(success_rate: success_percentage)
  end
end
