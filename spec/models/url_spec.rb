# frozen_string_literal: true

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
end
