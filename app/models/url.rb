# frozen_string_literal: true

# == Schema Information
#
# Table name: urls
#
#  id         :uuid             not null, primary key
#  click      :integer          default(0)
#  deleted    :boolean          default(FALSE)
#  long_url   :string
#  short_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  batch_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_urls_on_batch_id  (batch_id)
#  index_urls_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (batch_id => batches.id)
#  fk_rails_...  (user_id => users.id)
#

class Url < ApplicationRecord
  include Taggable
  
  belongs_to :batch
  belongs_to :user
  validates :long_url, presence: true, length: { minimum: 30 }
  validates :user_id, :batch_id, :short_url, presence: true
end
