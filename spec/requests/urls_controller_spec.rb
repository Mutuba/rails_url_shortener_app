# frozen_string_literal: true

# test/controllers/urls_controller_spec.rb

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
    it 'contains the file to be uploaded' do
      post '/urls/create', params: { url: { file: file } }
      expect(response).to redirect_to(new_url_path)
      expect(UrlsBulkImportJob).to have_been_enqueued.exactly(:once)
      expect(flash[:alert]).to eq 'Upload in progress. Please sit tight'
    end
  end
end

# describe UrlsController, 'as administrator' do
#   include ActiveJob::TestHelper

#   before do
#     sign_in users(:admin)
#   end

#   describe '#create' do
#     describe 'with valid parameters' do
#       it 'redirects to the imports list' do
#         assert_difference 'UserImport.count' do
#           post :create, params: { user_import: { users_csv: csv_attachment } }
#         end
#         assert_redirected_to user_imports_path
#         expect(flash[:alert]).must_equal 'Upload in progress. Please sit tight.'
#       end

#       it 'enqueues one job to process the import' do
#         assert_enqueued_with(job: ProcessImportedUsersJob) do
#           post :create, params: { user_import: { users_csv: csv_attachment } }
#         end
#       end
#     end

#     describe 'with no file upload specified' do
#       it 'displays the new screen again' do
#         assert_no_enqueued_jobs do
#           post :create, params: { user_import: { users_csv: '' } }
#         end
#         assert_response :success
#       end
#     end
#   end
# end
