FactoryBot.define do
  factory :guest do
    association :event
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    side { :bride }
    rsvp_status { :pending }
  end
end
