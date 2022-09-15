class Url < ApplicationRecord
  belongs_to :batch
  # belongs_to :user
  validates :long_url, presence: true, length: { minimum: 30 }
end
