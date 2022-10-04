# frozen_string_literal: true

# spec/factories/url.rb
FactoryBot.define do
  factory :url do
    long_url { 'http://example.com/foobar.html' }
    short_url { Faker::Internet.url }
    batch
    user
  end
end
