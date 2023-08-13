# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileWriterService, type: :service do
  let(:current_user) { create(:user) }
  let(:file) do
    Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_urls_upload_file.csv'),
                                 'text/csv')
  end
  let(:base_url) { 'http://example.com' }

  subject(:file_writer_service) do
    described_class.call(
      file:,
      base_url:,
      current_user:,
    )
  end

  describe '#call' do
    context 'with valid CSV file' do
      it 'imports URLs and performs necessary actions' do
        expect do
          file_writer_service
        end.to have_enqueued_job(UrlsCsvBatchUploadJob).exactly(:once)
        perform_enqueued_jobs
        assert_performed_jobs 1
        expect { file_writer_service }.not_to raise_error
      end
    end
  end

  # describe '#call with bad data/with invalid CSV file' do
  #   let(:current_user) { create(:user) }
  #   let(:base_url) { Faker::Internet.url }
  #   let(:file) do
  #     Rack::Test::UploadedFile.new(
  #       Rails.root.join('spec/fixtures/bad_csv_data_file.csv'), 'text/csv'
  #     )
  #   end

  #   before do
  #     allow(FileWriterService).to receive(:call).with(file:,
  #                                                     base_url:,
  #                                                     current_user:)
  #                                                     .and_raise(Errno::ENOENT)

  #   end
  #   context 'when the file is not found' do
  #     it 'record failed urls' do
  #       expect(FileWriterService.call(file:, base_url:, current_user:))
  #       .to raise_error(Errno::ENOENT)
  #     end
  #   end
  # end
end
