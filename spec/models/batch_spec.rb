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
require 'rails_helper'

RSpec.describe Batch, type: :model do
  # Association test
  it { should belong_to(:user) }

  # Validation test
  it { should validate_presence_of(:user_id) }

  it { should have_many(:urls) }
  it { should have_many(:failed_urls) }
end
