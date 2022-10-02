# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlShortenerChannel, type: :channel do
  before do
    current_user = create :user
    stub_connection current_user: current_user
  end

  it 'rejects when no batch id' do
    subscribe
    expect(subscription).to be_rejected
  end

  it 'subscribes to a stream when room id is provided' do
    subscribe batch_id: 42

    expect(subscription).to be_confirmed
    expect(subscription.streams[0]).to include('42')
  end
end
