# frozen_string_literal: true

# == Schema Information
#
# Table name: batches
#
#  id           :uuid             not null, primary key
#  deleted      :boolean          default(FALSE)
#  name         :string           not null
#  success_rate :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_batches_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Batch < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  has_many :urls, class_name: 'Url', dependent: :destroy
  has_many :failed_urls, class_name: 'FailedUrl', dependent: :destroy

  scope :active, -> { where(deleted: false) }
  scope :with_success_rate_nil, -> { where(success_rate: nil) }
  scope :recently_created, -> { order(created_at: :desc) }
end
