FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
  end

  factory :guest_user, class: "User" do
    username { "ゲストユーザー" }
    email { "guest@example.com" }
    password { "securepassword" }
    password_confirmation { "securepassword" }
  end
end
