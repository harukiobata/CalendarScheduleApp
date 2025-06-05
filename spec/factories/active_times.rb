FactoryBot.define do
  factory :active_time do
    user { nil }
    day_of_week { 1 }
    start_time { "2025-06-05 07:57:41" }
    end_time { "2025-06-05 07:57:41" }
    granularity_minutes { 1 }
  end
end
