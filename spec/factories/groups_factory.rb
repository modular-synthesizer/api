FactoryBot.define do
  factory :empty_group, class: Modusynth::Models::Permissions::Group do
    factory :group do
      slug { 'custom-slug' }
    end
  end
end