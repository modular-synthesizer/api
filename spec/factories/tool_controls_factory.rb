FactoryBot.define do
  factory :tool_control, class: Modusynth::Models::Tools::Control do
    component { 'TestComponent' }
  end
end