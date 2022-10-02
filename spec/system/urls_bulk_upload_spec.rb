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
    # allow(UrlsBulkImportJob).to receive(:perform_later)
  end

  scenario 'POST #create' do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Log in'
    click_link 'Upload Urls'
    page.attach_file('url_file', Rails.root.join('spec/fixtures/test_file.csv'))
    click_button 'Upload File'

    expect(page).to have_content('Upload in progress. Please sit tight')
  end

  scenario 'File missing on upload' do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Log in'
    click_link 'Upload Urls'
    click_button 'Upload File'
    expect(page).to have_content('Oops! File missing')
  end
end
