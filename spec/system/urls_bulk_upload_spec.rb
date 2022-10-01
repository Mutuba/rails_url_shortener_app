# frozen_string_literal: true

require 'rails_helper'
require 'csv'

describe 'User uploads urls using csv file', type: :system do
  let(:header) { 'long_url, cuctom name' }
  let(:row2) { "#{Faker::Internet.url}, #{Faker::Internet.url}" }
  let(:row3) { "#{Faker::Internet.url}, #{Faker::Internet.url}" }
  let(:rows) { [header, row2, row3] }

  let(:file_path) { 'tmp/test.csv' }
  let!(:csv) do
    CSV.open(file_path, 'w') do |csv|
      rows.each do |row|
        csv << row.split(',')
      end
    end
  end

  before do
    @user = create :user
    visit new_user_session_path
    allow(UrlsBulkImportJob).to receive(:perform_later).and_return(nil)
  end

  scenario 'POST #create' do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Log in'
    click_link 'Upload Urls'
    page.attach_file('url_file', Rails.root.join('spec/fixtures/test_file.csv'))
    click_button 'Upload File'

    expect(page).to have_content('Upload in progress. Please sit tight')

    # allow(Hotel).to receive(:import).with("foo.txt")
    # post :import, file: "foo.txt"
    # post "admin/users/upload", :user => @user, :user_csv =>

    # Make sure to swap this as well
    # expect(response).to be_successful
    # expect(response).to have_http_status(302) # Expects a HTTP Status code of 302
    # end
  end
end

# describe 'User signs with correct credentials', type: :system do
#   before do
#     @user = create :user
#     visit new_user_session_path
#   end
#   scenario 'valid with registered account' do
#     fill_in 'user_email', with: @user.email
#     fill_in 'user_password', with: @user.password
#     click_button 'Log in'

#     expect(page).to have_content('Signed in successfully.')
#     # visit urls_create_url
#     binding.pry
#   end
# end
