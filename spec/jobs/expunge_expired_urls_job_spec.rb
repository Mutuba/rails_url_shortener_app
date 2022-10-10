# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpungeExpiredUrlsJob, type: :job do
  before do
    allow(ExpungeExpiredUrlsService).to receive(:call)
  end
  it 'uploads a urls by enqueuing job' do
    ExpungeExpiredUrlsJob.perform_later
    expect(ExpungeExpiredUrlsJob).to have_been_enqueued.exactly(:once)
  end
end
