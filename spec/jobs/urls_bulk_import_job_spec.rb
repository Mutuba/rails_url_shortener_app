# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsBulkImportJob, type: :job do
  describe '#perform_later' do
    let(:base_url) { Faker::Internet.url }
    let(:string_file_path) { "/tmp/bulk-import #{SecureRandom.uuid}.csv" }

    before do
      allow(BulkUrlsImportService).to receive(:call)
      @user = create :user
    end

    it 'uploads a urls by enqueuing job' do
      UrlsBulkImportJob.perform_later(string_file_path, base_url, @user)
      expect(UrlsBulkImportJob).to have_been_enqueued.exactly(:once)
    end
  end
end
