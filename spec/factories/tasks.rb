FactoryBot.define do
  factory :task, class: Task do
    association :user, factory: :user
    association :author, factory: :user

    title { "Cook #{Faker::Dessert.variety}" }
  end
end
