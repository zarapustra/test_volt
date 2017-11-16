FactoryBot.define do
  factory :user do
    nickname { Faker::Name.first_name.downcase }
    email { Faker::Internet.email.downcase }
    password 'password'
    time_zone 'Amsterdam'
    after :create do |u|
      u.avatar = File.open(Rails.root.join('spec', 'support', 'one.jpg'))
      u.save
    end
  end
end
