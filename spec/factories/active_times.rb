FactoryBot.define do
  factory :active_time do
    association :user
    day_of_week { rand(0..6) }
    start_time { Time.zone.parse("00:00") }
    end_time { Time.zone.parse("23:59") }
    granularity_minutes { 30 }
  end
end
