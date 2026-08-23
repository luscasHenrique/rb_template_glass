FactoryBot.define do
  factory :schedule_guest do
    schedule_item { nil }
    user { nil }
    status { 1 }
  end
end
