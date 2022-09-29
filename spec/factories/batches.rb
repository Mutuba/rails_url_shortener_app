# frozen_string_literal: true

# spec/factories/batch.rb
FactoryBot.define do
  factory :batch do
    name { Faker::Internet.url }
  end
end
