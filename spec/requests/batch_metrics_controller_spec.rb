# frozen_string_literal: true

# spec/controllers/batch_metrics_controller_spec.rb

require 'rails_helper'
RSpec.describe 'BatchMetrics', type: :request do
  describe 'GET /batch_urls' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user:) }
    let!(:url) { create_list(:url, 10, user:, batch:) }

    before do
      sign_in user
      allow(Batch).to receive(:find_by).and_return(batch)
    end

    it 'returns stats for current batch' do
      get batch_metrics_batch_urls_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET /batch/stats' do
    let(:user) { create(:user) }
    let!(:batches) { create_list(:batch, 10, user:) }
    let!(:url) { create(:url, user:, batch: batches[0]) }
    before do
      sign_in user
    end
    it 'return available batches' do
      get batch_metrics_batch_stats_path

      expect(response.status).to eq 200
    end
  end

  describe 'GET /upload_status/' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user:) }
    let!(:url) { create(:url, user:, batch:) }

    context 'when batches exist' do
      before do
        sign_in user
      end
      it 'request is successful' do
        get batch_metrics_upload_status_path

        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end

    context 'when batches is empty' do
      before do
        sign_in user
        empty_relation = instance_double(ActiveRecord::Relation, where: Batch.none)
        allow(user).to receive(:batches).and_return(empty_relation)
      end

      it 'request is successful' do
        get batch_metrics_upload_status_path

        expect(response.body).to include('Sorry, batch number not found!')
      end
    end
  end
end
