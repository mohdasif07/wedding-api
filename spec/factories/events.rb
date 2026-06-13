FactoryBot.define do
  factory :event do
    association :user
    title { "Wedding" }
    description { "Main wedding ceremony" }
    venue { "Grand Hall" }
    event_date { 30.days.from_now.to_date }
    start_time { "10:00" }
    end_time { "14:00" }
    status { :planned }
  end
end
