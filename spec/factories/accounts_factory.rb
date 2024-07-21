FactoryBot.define do
  factory :account, class: ::Modusynth::Models::Account do

    username { Faker::Alphanumeric.unique.alphanumeric(number: 10, min_alpha: 10) }
    email { Faker::Internet.unique.free_email }
    password { 'testpassword' }
    password_confirmation { 'testpassword' }

    factory :account_without_rights do; end

    factory :babausse do
      username { 'babausse' }
      email { 'courtois.vincent@outlook.com' }
      after :create do |account|
        account.groups = [ create(:full_rights) ]
        account.save!
      end
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

    factory(:random_admin) do
      admin { true }
      after :create do |account|
        group = Modusynth::Models::Permissions::Group.find_by(slug: 'full-rights')
        if group.nil?
          account.groups = [ create(:full_rights) ]
        else
          account.groups.push(group)
        end
        account.save!
      end
    end
  end
end