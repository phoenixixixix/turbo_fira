FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "welcome_#{n}@mail.com" }
    password { "welcome" }
    password_confirmation { "welcome" }
  end
end
