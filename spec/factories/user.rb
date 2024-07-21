# frozen_string_literal: true

# spec/factories/user.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email  }
    password { 'SecretPassword123' }
    password_confirmation { 'SecretPassword123' }
  end
end
