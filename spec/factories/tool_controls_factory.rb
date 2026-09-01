FactoryBot.define do
  factory :tool_control, class: Modusynth::Models::Blueprints::Control do
    component { 'TestComponent' }
  end
end