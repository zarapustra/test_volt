FactoryGirl.define do
  factory :post do
    title  Faker::Lorem.sentence
    body Faker::Lorem.paragraph
    published_at Time.current.to_formatted_s(:datetime)
    user_id 1

    factory :post_month_old do
      published_at 1.year.month.to_formatted_s(:datetime)
    end
  end
end
