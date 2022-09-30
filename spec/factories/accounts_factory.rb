FactoryBot.define do
  factory :account, class: ::Modusynth::Models::Account do
    factory :babausse do
      username { 'babausse' }
      password { 'testpassword' }
      password_confirmation { 'testpassword' }
      email { 'courtois.vincent@outlook.com' }
    end

    factory :cidualia do
      username { 'Cidualia' }
      password { 'testpassword' }
      password_confirmation { 'testpassword' }
      email { 'cidualia@modusynth.com' }
    end

    # Used ONLY for authentication errors in controllers tests.
    factory :authenticator do
      username { 'authenticator' }
      password { 'testpassword' }
      password_confirmation { 'testpassword' }
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