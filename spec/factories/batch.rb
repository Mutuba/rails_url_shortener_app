# frozen_string_literal: true

# spec/factories/batch.rb
FactoryBot.define do
  factory :batch do
    name { Faker::Name.name }
    association :user, factory: :user
  end
end
