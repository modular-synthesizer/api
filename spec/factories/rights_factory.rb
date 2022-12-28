FactoryBot.define do
  factory :empty_scope, class: Modusynth::Models::Permissions::Right do
    factory :scope do
      label { Faker::Alphanumeric.alpha(number: 10) }
    end
  end
end