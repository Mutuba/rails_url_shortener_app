# frozen_string_literal: true

require 'rails_helper'
require 'csv'

describe 'User uploads urls using csv file', type: :system do
  before do
    allow(SecureRandom).to receive(:uuid).and_return('12abcd1234')
    @user = create :user
    visit new_user_session_path
  end

  scenario 'POST #create' do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Log in'
    click_link 'Upload Urls'
    page.attach_file('url_file', Rails.root.join('spec/fixtures/test_file.csv'))
    click_button 'Upload File'
    perform_enqueued_jobs
    assert_performed_jobs 1
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
