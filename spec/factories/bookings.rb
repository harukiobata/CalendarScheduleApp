FactoryBot.define do
  factory :booking do
    user { nil }
    name { "MyString" }
    email { "MyString" }
    start_time { "2025-08-08 16:45:25" }
    end_time { "2025-08-08 16:45:25" }
    status { "MyString" }
  end
end
