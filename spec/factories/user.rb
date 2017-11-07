FactoryGirl.define do
  factory :user do
    nickname { Faker::Name.first_name }
    email { Faker::Internet.email }
    password 'password'
  end
end
