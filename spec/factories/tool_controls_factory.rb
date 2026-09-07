FactoryBot.define do
  factory :tool_control, class: Modusynth::Models::Blueprints::ControlTemplate do
    component { 'TestComponent' }
  end
end
