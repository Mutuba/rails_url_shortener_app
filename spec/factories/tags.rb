# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    name { Faker::Name.name }
    association :taggable, factory: :url
  end
end
