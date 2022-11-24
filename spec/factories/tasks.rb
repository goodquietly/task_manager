FactoryBot.define do
  factory :task do
    title { Faker::Task.title }
  end
end
