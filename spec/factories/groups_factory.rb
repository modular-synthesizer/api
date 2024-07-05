FactoryBot.define do
  factory :empty_group, class: Modusynth::Models::Permissions::Group do
    factory :group do
      slug { 'custom-slug' }
    end

    factory :full_rights do
      slug { 'full-rights' }
      after :create do |group|
        group.scopes = [
          create(:scope, label: Rights::CATEGORIES_WRITE),
          create(:scope, label: Rights::CATEGORIES_READ)
        ]
        group.save!
      end
    end
  end
end