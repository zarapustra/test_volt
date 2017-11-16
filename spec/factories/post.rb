FactoryBot.define do
  factory :post do
    title  Faker::Lorem.sentence
    body Faker::Lorem.paragraph
    published_at Time.now
    user

    factory :post_month_old do
      published_at 1.year.month
    end
  end
end
