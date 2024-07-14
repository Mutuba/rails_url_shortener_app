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
require 'rails_helper'

RSpec.describe Url, type: :model do
  # Association test
  it { should belong_to(:user) }
  it { should belong_to(:batch) }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(number: 10)).for :long_url }

  # Validation test
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:batch_id) }
  it { should validate_presence_of(:long_url) }
  it { should validate_presence_of(:short_url) }
  it_behaves_like "taggable"
end
