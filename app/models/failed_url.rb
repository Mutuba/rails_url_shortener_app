# frozen_string_literal: true

# == Schema Information
#
# Table name: failed_urls
#
#  id         :uuid             not null, primary key
#  long_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  batch_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_failed_urls_on_batch_id  (batch_id)
#  index_failed_urls_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (batch_id => batches.id)
#  fk_rails_...  (user_id => users.id)
#
class FailedUrl < ApplicationRecord
  belongs_to :batch
  belongs_to :user
end
