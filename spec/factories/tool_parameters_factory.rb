FactoryBot.define do
  factory :tool_parameter, class: Modusynth::Models::Blueprints::Parameter do
    name { 'test parameter' }
    field { 'test field' }
  end
end