# test/factories/profiles.rb
FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    bio { Faker::Lorem.sentence }
    user # Isso diz ao FactoryBot para criar um usuário automaticamente se não passarmos um
  end
end
