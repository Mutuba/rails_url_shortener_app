# == Schema Information
#
# Table name: visits
#
#  id          :uuid             not null, primary key
#  ip_address  :string
#  visit_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  session_id  :string
#  url_id      :uuid             not null
#  user_id     :uuid             not null
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
require 'rails_helper'

RSpec.describe Visit, type: :model do
  # Association tests
  it { should belong_to :user }
  it { should belong_to :url }
  it { should have_db_column(:visit_count).of_type(:integer) }
end
