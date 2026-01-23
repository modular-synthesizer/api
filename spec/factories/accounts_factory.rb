FactoryBot.define do
  factory :account, class: Modusynth::Models::Account do
    username { Faker::Alphanumeric.unique.alphanumeric(number: 10, min_alpha: 10) }
    email { Faker::Internet.unique.free_email }
    password { 'testpassword' }
    password_confirmation { 'testpassword' }

    factory :account_without_rights do
    end

    # Used ONLY for authentication errors in controllers tests.
    factory :authenticator do
      username { 'authenticator' }
      email { 'authenticator@modusynth.com' }
    end

    factory(:random_admin) do
      admin { true }
      after :create do |account|
        account.groups.push(Modusynth::Models::Permissions::Group.find_by(slug: 'full-rights'))
        account.save!
      end
      factory(:admin) do
        username { 'admin' }
        uuid { 'admin-uuid' }
      end

      factory :babausse do
        username { 'babausse' }
        uuid { 'babausse-uuid' }
        email { 'courtois.vincent@outlook.com' }
      end
    end
  end
end
