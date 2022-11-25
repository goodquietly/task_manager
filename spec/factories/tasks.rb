FactoryBot.define do
  factory :task, class: Task do
    association :user, factory: :user
    association :author, factory: :user

    title { Faker::String.random(length: 1..35) }
  end
end
