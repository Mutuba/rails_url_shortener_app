class Url < ApplicationRecord
  require 'csv'
  require 'securerandom'
  # belongs_to :user
  # belongs_to :category
  validates :long_url, presence: true, length: { minimum: 30 }
  before_create :generate_short_url, :sanitize_url

  def generate_short_url
    self.short_url = rand(36**8).to_s(36)
  end

  def sanitize_url
    long_url.strip!
    sanitize_url = long_url.downcase.gsub(%r{(https?://)|(www\.)}, '')
    "http://#{sanitize_url}"
  end

  # Bulk upload urls
  def self.import(_file)
    byebug
    urls_hash = []
    batch_no = SecureRandom.hex

    # CSV.foreach(file.path, headers: true) do |row|
    #   url_hash = Url.new

    #   url_hash.batch_no = batch_no
    #   url_hash.long_url = row[0]
    #   url_hash.created_at = Time.now
    #   url_hash.updated_at = Time.now
    #   url_hash.save!
    # end
  end
end
