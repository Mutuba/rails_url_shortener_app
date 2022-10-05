# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.shared_context :login_user do
  let(:user) { create(:user) }
  before do
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
  end
end

describe 'User uploads urls using csv file', type: :system do
  include_context :login_user

  before do
    allow(SecureRandom).to receive(:uuid).and_return('12abcd1234')
  end

  scenario 'POST #create' do
    click_link 'Upload Urls'
    page.attach_file('url_file', Rails.root.join('spec/fixtures/test_file.csv'))
    click_button 'Upload File'
    expect(UrlsBulkImportJob).to have_been_enqueued.exactly(:once)
    perform_enqueued_jobs
    assert_performed_jobs 1
    expect(page).to have_content('Upload in progress. Please sit tight')
    click_link 'Batch Metrics'
    expect(page).to have_content('Batch Metrics')    
    click_on(class: 'accordion-button')
    expect(page).to have_button('View Batch Urls')
    click_on 'View Batch Urls'
  end

  scenario 'File missing on upload' do
    click_link 'Upload Urls'
    click_button 'Upload File'
    expect(page).to have_content('Oops! File missing')
  end
end
