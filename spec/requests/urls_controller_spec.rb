# frozen_string_literal: true

# spec/controllers/urls_controller_spec.rb

require 'rails_helper'
RSpec.describe 'Urls', type: :request do
  describe 'POST /urls/create' do
    let(:user) { create(:user) }
    let(:file) do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_file.csv'), 'text/csv')
    end

    before do
      sign_in user
    end
    context 'params contains the file to be uploaded' do
      it 'uploads the uploaded' do
        post '/urls/create', params: { url: { file: } }
        expect(response).to redirect_to(new_url_path)
        expect(UrlsBulkImportJob).to have_been_enqueued.exactly(:once)
        perform_enqueued_jobs
        assert_performed_jobs 1
        expect(Batch.count).to eq(1)
        expect(flash[:alert]).to eq 'Upload in progress. Please sit tight'
      end
    end

    context 'file to be uploaded is missing in param' do
      it 'uploads the uploaded' do
        post '/urls/create', params: {}
        expect(response).to redirect_to(new_url_path)
        expect(flash[:alert]).to eq 'Oops! File missing'
        expect(UrlsBulkImportJob).not_to have_been_enqueued.exactly(:once)
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
        get '/urls/'
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
      allow(Url).to receive(:find_by).and_return(url)
    end
    context 'params contains the file to be uploaded' do
      it 'uploads the uploaded' do
        get '/urls/show'

        expect(response.status).to eq 302
        expect(url.click).to eq(previous_clicks + 1)
      end
    end
  end
end
