# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurgeExpiredUrlsService, type: :model do
  let!(:user) { create(:user) }
  let!(:batch) { create(:batch, user:) }

  before do
    travel_to 10.days.ago do
      create_list(:url, 10, user:, batch:)
    end
    Time.current
    create_list(:url, 10, user:, batch:)
  end

  it 'finds urs older than 10 days and deletes them' do
    expect(Url.all.count).to eq 20
    PurgeExpiredUrlsService.call
    expect(Url.count).to eq 10
  end
end
