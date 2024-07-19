# == Schema Information
#
# Table name: visits
#
#  id         :uuid             not null, primary key
#  ip_address :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url_id     :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_visits_on_url_id   (url_id)
#  index_visits_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (url_id => urls.id)
#  fk_rails_...  (user_id => users.id)
#
class Visit < ApplicationRecord
  belongs_to :url, counter_cache: true
  belongs_to :user
end
