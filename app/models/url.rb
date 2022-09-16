# == Schema Information
#
# Table name: urls
#
#  id         :uuid             not null, primary key
#  click      :integer          default(0)
#  long_url   :string
#  short_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  batch_id   :uuid             not null
#
# Indexes
#
#  index_urls_on_batch_id  (batch_id)
#
# Foreign Keys
#
#  fk_rails_...  (batch_id => batches.id)
#
class Url < ApplicationRecord
  belongs_to :batch
  # belongs_to :user
  validates :long_url, presence: true, length: { minimum: 30 }
end
