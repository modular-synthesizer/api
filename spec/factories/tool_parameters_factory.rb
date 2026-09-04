FactoryBot.define do
  factory :tool_parameter, class: Modusynth::Models::Blueprints::ParameterTemplate do
    name { 'test parameter' }
    field { 'test field' }
  end
end