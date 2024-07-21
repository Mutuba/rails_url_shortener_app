# frozen_string_literal: true

# spec/controllers/batch_metrics_controller_spec.rb

require 'rails_helper'
RSpec.describe BatchMetricsController, type: :request do
  describe 'GET /batch_urls' do
    let(:user) { create(:user) }
    let(:batch) { create(:batch, user:) }
    let(:url) { create_list(:url, 10, :with_tags, user:, batch:) }

    before do
      sign_in user
    end

    it 'returns stats for current batch' do
      get batch_urls_path(id: batch.id)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /batch/stats' do
    let(:user) { create(:user) }
    let(:batches) { create_list(:batch, 10, user:) }
    let(:url) { create(:url, user:, batch: batches[0]) }
    before do
      sign_in user
    end
    it 'return available batches' do
      get batch_stats_path

      expect(response.status).to eq 200
    end
  end

  describe 'GET /upload_status/' do
    let(:user) { create(:user) }
    let(:batch) { create(:batch, user:) }
    let(:url) { create(:url, user:, batch:) }

    context 'when batches exist' do
      before do
        sign_in user
      end
      it 'request is successful' do
        get upload_status_path

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
        get upload_status_path

        expect(response.body).to include('Sorry, batch number not found!')
      end
    end
  end

  describe "DELETE /delete" do
    let(:user) { create(:user) }
    let(:batch) { create(:batch, user:) }

    before do
      sign_in user
    end

    context 'when batches exist' do
      it 'request is successful' do
        delete batch_metric_path(batch)
        batch.reload        
        expect(batch.deleted).to eq(true)
        expect(response.status).to eq 302
        expect(flash[:alert]).to eq 'Batch marked as deleted successfully.'
      end
    end
  end
end
