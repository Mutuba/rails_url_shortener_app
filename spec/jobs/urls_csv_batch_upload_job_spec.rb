# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsCsvBatchUploadJob, type: :job do
  let(:user) { create(:user) } 
  let(:base_url) { Faker::Internet.url }
  let(:string_file_path) do
    'spec/fixtures/sample_urls_upload_file.csv'
  end
  let(:file_path) do
    Rails.root.join(string_file_path)  # Absolute path of the file
  end

  describe '#perform_later' do
    it 'uploads a urls by enqueuing job' do
      expect {
        UrlsCsvBatchUploadJob.perform_later(
          string_file_path: string_file_path,
           base_url: base_url,
          current_user: user
        )
      }.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by 1
   
      perform_enqueued_jobs

       expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq(0)
    end
  end

  describe '#perform_now' do
    subject(:perform_job) do
      described_class.perform_now(
        string_file_path:,
        base_url:,
        current_user: user,
      )
    end

    it 'calls the service with correct params' do
      expect(UrlsCsvBatchUploadService).to receive(:call).with(
        file_path:,
        base_url:,
        current_user: user,
      )
      perform_job
      expect { perform_job }.not_to raise_error
    end
  end

  describe '#perform_now raises errors if any' do
    before do
      allow(UrlsCsvBatchUploadService).to receive(:call).and_raise(
        StandardError,
        'Some error',
      )
    end

    subject(:perform_job) do
      described_class.perform_now(
        string_file_path:,
        base_url:,
        current_user: user,
      )
    end

    it 'calls the service with correct params' do
      expect(Rails.logger).to receive(:error).with(
        /An error occurred:/,
      )
      perform_job
    end
  end
end
