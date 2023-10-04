FactoryBot.define do
  factory :user do
    email { "welcome@mail.com" }
    password { "welcome" }
    password_confirmation { "welcome" }
  end
end
