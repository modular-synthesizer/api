FactoryBot.define do
  factory :tool_parameter, class: Modusynth::Models::Tools::Parameter do
    name { 'test parameter' }
    field { 'test field' }
  end
end