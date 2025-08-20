FactoryBot.define do
  factory :booking do
    association :owner, factory: :user
    name { "予約 太郎" }
    email { "example@example.com" }
    start_time { "2025-08-08 16:45:25" }
    end_time { "2025-08-08 16:45:25" }
    memo { "備考メモ" }
  end
end
