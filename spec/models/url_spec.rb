require 'rails_helper'

RSpec.describe Url, type: :model do
  # Association test
  it { should belong_to(:user) }
  it { should belong_to(:batch) }

  # Validation test
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:batch_id) }
  it { should validate_presence_of(:long_url) }
  it { should validate_presence_of(:short_url) }
end
