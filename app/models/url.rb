class Url < ApplicationRecord
  require 'csv'
  require 'securerandom'
  # belongs_to :user
  # belongs_to :category
  validates :long_url, :short_url, presence: true, length: { minimum: 30 }
end
