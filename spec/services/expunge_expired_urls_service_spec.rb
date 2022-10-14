# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpungeExpiredUrlsService, type: :model do
  let!(:user) { create(:user) }
  let!(:batch) { create(:batch, user: user) }

  before do
    travel_to 10.days.ago do
      create_list(:url, 10, user: user, batch: batch)
    end
    Time.current
    create_list(:url, 10, user: user, batch: batch)
  end

  it ' finds urs and deletes them' do
    Url.where('created_at < ?', 10.days.ago)

    expect(Url.all.count).to eq 20
    ExpungeExpiredUrlsService.call

    expect(Url.count).to eq 0
  end
end
