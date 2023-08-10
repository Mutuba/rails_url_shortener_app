# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsCsvBatchUploadJob, type: :job do
  let(:base_url) { Faker::Internet.url }
  let(:string_file_path) { 'spec/fixtures/sample_urls_upload_file.csv' }
  let(:file_path) { Rails.root.join(string_file_path) }

  describe '#perform_later' do
    subject(:perform_job) do
      UrlsCsvBatchUploadJob.perform_later(string_file_path, base_url, @user)
    end

    before do
      @user = create(:user)
    end

    it 'uploads a urls by enqueuing job' do
      expect { perform_job }.to have_enqueued_job(UrlsCsvBatchUploadJob).exactly(:once)
    end
  end

  describe '#perform_now' do
    before do
      @user = create :user
    end

    subject(:perform_job) do
      described_class.perform_now(
        string_file_path:,
        base_url:,
        current_user: @user,
      )
    end

    it 'calls the service with correct params' do
      expect(UrlsCsvBatchUploadService).to receive(:call).with(
        file_path:,
        base_url:,
        current_user: @user,
      )
      perform_job
      expect { perform_job }.not_to raise_error
    end
  end

  describe '#perform_now raises errors if any' do
    before do
      @user = create :user
      allow(UrlsCsvBatchUploadService).to receive(:call).and_raise(
        StandardError,
        'Some error',
      )
    end

    subject(:perform_job) do
      described_class.perform_now(
        string_file_path:,
        base_url:,
        current_user: @user,
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
