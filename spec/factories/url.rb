# frozen_string_literal: true

# spec/factories/url.rb
FactoryBot.define do
  factory :url do
    long_url { Faker::Internet.url }
    short_url { Faker::Internet.url }
  end
end
