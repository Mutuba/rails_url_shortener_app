# frozen_string_literal: true

# spec/controllers/urls_controller_spec.rb

require 'rails_helper'
RSpec.describe 'Urls', type: :request do
  describe 'POST /urls/create' do
    let(:user) { create(:user) }
    let(:file) do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/sample_urls_upload_file.csv'),
        'text/csv',
      )
    end

    before do
      sign_in user
    end
    context 'params contains the file to be uploaded' do
      it 'uploads the uploaded' do
        post urls_path, params: { url: { file: file } }
        expect(response).to redirect_to(new_url_path)

        expect(UrlsCsvBatchUploadJob).to have_been_enqueued.exactly(:once)
        perform_enqueued_jobs
        assert_performed_jobs 1
        expect(Batch.count).to eq(1)
      end
    end

    context 'file to be uploaded is missing in param' do
      it 'uploads the uploaded' do
        post urls_path, params: {}
        expect(response).to redirect_to(new_url_path)
        expect(flash[:alert]).to eq 'Oops! File missing'
        expect(UrlsCsvBatchUploadJob).not_to have_been_enqueued.exactly(:once)
      end
    end
  end

  describe 'GET /urls/index' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user:) }
    let!(:url) { create_list(:url, 10, user:, batch:) }

    before do
      sign_in user
    end
    context 'params contains the file to be uploaded' do
      it 'uploads the uploaded' do
        get urls_path
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /urls/show' do
    let(:user) { create(:user) }
    let!(:batch) { create(:batch, user:) }
    let!(:url) { create(:url, user:, batch:) }
    let(:previous_clicks) { 0 }
    before do
      sign_in user
    end
    context 'params contains the file to be uploaded' do
      it 'uploads the uploaded' do
        get url_path(url)
        url.reload
        expect(url.click).to eq(previous_clicks + 1)
      end
    end
  end

  describe 'DELETE /urls/delete' do
    let(:user) { create (:user) }
    let(:batch) { create(:batch, user:) }
    let(:url) { create(:url, user:, batch:) }

    before do
      sign_in user
      allow(Url).to receive(:find).and_return(url)
    end

    context 'when the url id is passed in params' do
      it 'deleted the url' do
        delete url_path(url)
        url.reload        
        expect(url.deleted).to eq(true)
        expect(response.status).to eq 302
        expect(flash[:alert]).to eq 'Url marked as deleted successfully.'
      end
    end
  end
end
