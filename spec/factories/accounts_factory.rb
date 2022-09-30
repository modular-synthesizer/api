FactoryBot.define do
  factory :account, class: ::Modusynth::Models::Account do

    username { Faker::Alphanumeric.unique.alphanumeric(number: 10, min_alpha: 10) }
    email { Faker::Internet.unique.free_email }
    password { 'testpassword' }
    password_confirmation { 'testpassword' }

    factory :babausse do
      username { 'babausse' }
      email { 'courtois.vincent@outlook.com' }
    end

    factory :cidualia do
      username { 'Cidualia' }
      email { 'cidualia@modusynth.com' }
    end

    # Used ONLY for authentication errors in controllers tests.
    factory :authenticator do
      username { 'authenticator' }
      email { 'authenticator@modusynth.com' }
    end

    factory :random_account do
      username { Faker::Internet.unique.username }
      email { Faker::Internet.unique.free_email }
      password { 'testpassword' }
      password_confirmation { 'testpassword' }
    end
  end
end