FactoryBot.define do
  factory :empty_group, class: Modusynth::Models::Permissions::Group do
    factory :group do
      slug { 'custom-slug' }
    end

    factory :full_rights do
      slug { 'full-rights' }
      after :create do |group|
        group.scopes = Rights.constants.map { |c| create(:scope, label: Rights.const_get(c)) }
        group.save!
      end
    end
  end
end