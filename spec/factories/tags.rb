FactoryBot.define do
  factory :tag do
    name { Faker::Name.name }
    association :taggable, factory: :url
  end
end