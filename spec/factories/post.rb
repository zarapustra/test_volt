FactoryBot.define do
  factory :post do
    title  Faker::Lorem.sentence
    body Faker::Lorem.paragraph
    published_at Time.now
    user

    factory :old_post do
      published_at 1.month.ago
    end
  end
end
