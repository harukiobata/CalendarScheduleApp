FactoryBot.define do
  factory :event do
    association :user
    title { "予定タイトル" }
    note { "メモ内容" }
    location { "東京" }
    category { "重要" }
    date { "2025-7-10" }
    start_time { "08:00" }
    end_time { "09:30" }
  end
end
