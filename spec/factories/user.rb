# frozen_string_literal: true

# spec/factories/user.rb
FactoryBot.define do
  # sequence :email do |n|
  #   "email_#{n}@tinyfyurls.com"
  # end

  # sequence :password do |n|
  #   "1404555121frddsa#{n}"
  # end

  factory :user do
    email { 'jane.doe@hey.com' }
    password { 'SecretPassword123' }
    password_confirmation { 'SecretPassword123' }
  end
end
