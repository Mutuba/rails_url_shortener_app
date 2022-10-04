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
        post '/urls/create', params: { url: { file: file } }
        expect(response).to redirect_to(new_url_path)
        expect(UrlsBulkImportJob).to have_been_enqueued.exactly(:once)
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
end
