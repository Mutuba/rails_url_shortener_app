# frozen_string_literal: true

# spec/controllers/batch_metrics_controller_spec.rb

require 'rails_helper'
RSpec.describe 'BatchMetrics', type: :request do
  describe 'GET /batch_urls' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user: user) }
    let!(:url) { create_list(:url, 10,  user: user, batch: batch) }

    before do
      sign_in user
      allow(Batch).to receive(:find_by).and_return(batch)
    end

    it 'returns stats for current batch' do
      get batch_urls_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET /batch/stats' do
    let(:user) { create(:user) }
    let!(:batches) { create_list(:batch, 10, user: user) }
    let!(:url) { create(:url, user: user, batch: batches[0]) }
    before do
      sign_in user
    end
    it 'return available batches' do
      get batch_stats_path

      expect(response.status).to eq 200
    end
  end

  describe 'GET /batch/upload_status/' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user: user) }
    let!(:url) { create(:url, user: user, batch: batch) }
    before do
      sign_in user
      allow(Batch).to receive(:find_by).and_return(batch)
    end
    context 'when a batch is available' do
      it 'uploads the uploaded' do
        get batch_upload_status_path

        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /current_upload_status/' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user: user) }
    let!(:url) { create(:url, user: user, batch: batch) }

    context 'when batch is not nil' do
      before do
        sign_in user
        allow(Batch).to receive(:find_by).and_return(batch)
      end
      it 'request is successful' do
        get current_upload_status_path

        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end

    context 'when batch is nil' do
      before do
        sign_in user
        allow(Batch).to receive(:last).and_return(nil)
      end
      it 'request is successful' do
        get current_upload_status_path

        expect(response.body).to include('Sorry, batch number not found!')
      end
    end
  end
end
