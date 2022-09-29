# frozen_string_literal: true

# spec/factories/user.rb
FactoryBot.define do
  sequence :email do |n|
    "email_#{n}@tinyfyurls.com"
  end

  sequence :password do |n|
    "1404555121frddsa#{n}"
  end

  factory :user do
    email
    password
    password_confirmation { password }
  end
end
