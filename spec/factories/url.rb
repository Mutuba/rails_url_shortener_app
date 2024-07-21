# frozen_string_literal: true

# spec/factories/url.rb
FactoryBot.define do
  factory :url do
    long_url { 'http://example.com/foobar.html' }
    short_url { Faker::Internet.url }
    association :batch, factory: :batch
    association :user, factory: :user

    trait :with_tags do
      after(:create) do |url|
        create_list(:tag, 3, taggable: url)
      end
    end
  end
end
