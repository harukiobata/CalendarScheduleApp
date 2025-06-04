FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
