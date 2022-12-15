FactoryBot.define do
  factory :empty_scope, class: Modusynth::Models::Permissions::Scope do
    factory :scope do
      label { Faker::Alphanumeric.alpha(number: 10) }
    end
  end
end