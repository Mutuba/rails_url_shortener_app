# frozen_string_literal: true
# # frozen_string_literal: true

# require 'rails_helper'

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
#   end
# end

# describe 'User signs in with bad credentials', type: :system do
#   before do
#     @user = create :user
#     visit new_user_session_path
#   end
#   scenario 'invalid with unregistered account' do
#     fill_in 'user_email', with: Faker::Internet.email
#     fill_in 'user_password', with: 'FakePassword123'
#     click_button 'Log in'

#     expect(page).to have_no_text 'Signed in successfully.'
#     expect(page).to have_text 'Invalid Email or password.'
#     expect(page).to have_no_link 'Sign Out'
#   end

#   scenario 'invalid with invalid password' do
#     fill_in 'user_email', with: @user.email
#     fill_in 'user_password', with: 'FakePassword123'
#     click_button 'Log in'

#     expect(page).to have_no_text 'Signed in successfully.'
#     expect(page).to have_text 'Invalid Email or password.'
#     expect(page).to have_no_link 'Sign Out'
#   end
# end
