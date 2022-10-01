# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch, type: :model do
  # Association test
  it { should belong_to(:user) }

  # Validation test
  it { should validate_presence_of(:user_id) }

  it { should have_many(:urls) }
  it { should have_many(:failed_urls) }
end
