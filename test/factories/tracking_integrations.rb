FactoryBot.define do
  factory :tracking_integration do
    provider_name { "MyString" }
    account_id { "MyString" }
    is_active { false }
  end
end
