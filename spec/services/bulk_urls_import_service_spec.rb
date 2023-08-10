
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsCsvBatchUploadService do
  let(:current_user) { create(:user) }
  let!(:file_path) { Rails.root.join('spec/fixtures/sample_urls_upload_file.csv') }
  let(:base_url) { 'http://example.com' }

  subject(:batch_upload_service) do
    described_class.call(
      file_path:,
      base_url:,
      current_user:,
    )
  end

  describe '#call' do
    context 'with valid CSV file' do
      it 'imports URLs and performs necessary actions' do
        expect { batch_upload_service }.to change { Url.count }.by(25)
        expect(current_user.urls.size).to eq(25)
        expect(current_user.batches.size).to eq(1)
        expect(current_user.batches[0].success_rate).to eq(100)
        expect do
          ActionCable.server.broadcast(
            "#{current_user.id}#{current_user.batches[0].id}",
            { content: '100' },
          )
        end.to have_broadcasted_to("#{current_user.id}#{current_user.batches[0].id}")
          .with(content: '100')

        expect { batch_upload_service }.not_to raise_error
      end
    end
  end

  describe '#call with bad data/with invalid CSV file' do
    let(:current_user) { create(:user) }
    let(:base_url) { Faker::Internet.url }
    let!(:file_path) { Rails.root.join('spec/fixtures/bad_csv_data_file.csv') }
    subject(:batch_upload_service) do
      described_class.call(
        file_path:,
        base_url:,
        current_user:,
      )
    end

    context 'when the file has invalid data' do
      it 'record failed urls' do
        UrlsCsvBatchUploadService.call(file_path:, base_url:, current_user:)
        expect(current_user.failed_urls.size).to eq(2)
        expect(current_user.batches[0].success_rate).to eq(33)
      end
    end

    context 'when csv file cannot be read' do
      before do
        allow(CSV).to receive(:foreach).and_raise(CSV::MalformedCSVError.new(
                                                    'Malformed CSV error message', 42
                                                  ))
      end

      it 'raises relevent errors' do
        expect do
          batch_upload_service
        end.to raise_error(CSV::MalformedCSVError,
                           'Malformed CSV error message in line 42.')
        expect(current_user.failed_urls.size).to eq(0)
      end
    end
  end
end

