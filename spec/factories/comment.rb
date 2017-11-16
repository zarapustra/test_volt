FactoryBot.define do
  factory :comment do
    body Faker::Lorem.sentence
    published_at Time.current
    user_id 1
  end
end
