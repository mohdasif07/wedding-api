FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user#{n}@example.com" }
    phone { Faker::PhoneNumber.phone_number }
    password { "password123" }
    password_confirmation { "password123" }
    role { :family_member }

    trait :admin do
      role { :admin }
    end
  end
end
