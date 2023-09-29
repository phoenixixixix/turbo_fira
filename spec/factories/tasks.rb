FactoryBot.define do
  factory :task do
    description { "todo" }
    status { 0 }
    stack
  end
end
