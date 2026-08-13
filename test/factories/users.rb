# test/factories/users.rb
FactoryBot.define do
  factory :user do
    # O Faker garante um e-mail único e válido para cada teste
    email { Faker::Internet.unique.email }
    # Fixamos a senha para o teste rodar rápido e não perdermos tempo
    password { "Senha@123" }
    password_confirmation { "Senha@123" }
    role { 0 } # Perfil comum padrão

    # Criamos uma "variação" (trait) para quando precisarmos de um Admin
    trait :admin do
      role { 1 }
    end
  end
end
