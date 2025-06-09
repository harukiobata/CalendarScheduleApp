FactoryBot.define do
  factory :event do
    user { nil }
    title { "MyString" }
    description { "MyText" }
    start_time { "2025-06-10 04:21:03" }
    end_time { "2025-06-10 04:21:03" }
    color { "MyString" }
    location { "MyString" }
  end
end
