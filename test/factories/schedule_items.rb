FactoryBot.define do
  factory :schedule_item do
    title { "MyString" }
    description { "MyText" }
    start_time { "2026-08-21 15:13:54" }
    end_time { "2026-08-21 15:13:54" }
    meeting_url { "MyString" }
    item_type { 1 }
    creator { nil }
    location { nil }
  end
end
