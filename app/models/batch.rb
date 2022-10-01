# frozen_string_literal: true

# == Schema Information
#
# Table name: batches
#
#  id           :uuid             not null, primary key
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
  validates_presence_of :user_id
  has_many :urls, class_name: 'Url'
  has_many :failed_urls, class_name: 'FailedUrl'
end
