FactoryBot.define do
  factory :account, class: ::Modusynth::Models::Account do
    factory :babausse do
      username { 'babausse' }
      password { 'testpassword' }
      password_confirmation { 'testpassword' }
      email { 'courtois.vincent@outlook.com' }
    end
  end
end