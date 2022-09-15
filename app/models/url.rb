class Url < ApplicationRecord
  require 'csv'
  require 'securerandom'
  # belongs_to :user
  validates :long_url, presence: true, length: { minimum: 30 }

end