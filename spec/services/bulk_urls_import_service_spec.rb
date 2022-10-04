# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BulkUrlsImportService, type: :model do
  describe '#call' do
    let(:current_user) { create(:user) }
    let(:base_url) { Faker::Internet.url }
    let!(:file_path) { Rails.root.join('spec/fixtures/test_file.csv') }
    it 'create a batch and urls' do
      BulkUrlsImportService.call(file_path: file_path, base_url: base_url,
                                 current_user: current_user)
      expect(current_user.urls.size).to eq(3)
      expect(current_user.batches.size).to eq(1)
      expect(current_user.batches[0].success_rate).to eq(100)
      expect do
        ActionCable.server.broadcast(
          "#{current_user.id}#{current_user.batches[0].id}", { content: '100' }
        )
      end
        .to have_broadcasted_to("#{current_user.id}#{current_user.batches[0]
        .id}").with(content: '100')
    end
  end

  describe '#call with bad data' do
    let(:current_user) { create(:user) }
    let(:base_url) { Faker::Internet.url }
    let!(:file_path) { Rails.root.join('spec/fixtures/bad_csv_data_file.csv') }

    it 'record failed urls' do
      BulkUrlsImportService.call(file_path: file_path, base_url: base_url,
                                 current_user: current_user)
      expect(current_user.failed_urls.size).to eq(2)
      expect(current_user.batches[0].success_rate).to eq(33)
    end
  end
end
