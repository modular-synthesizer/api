FactoryBot.define do
  factory :empty_control, class: Modusynth::Models::Blueprints::ControlTemplate do
    factory :knob do
      component { 'Knob' }
    end
    factory :button do
      component { 'Button' }
    end
    factory :control_port do
      component { 'Port' }
      payload { { x: 20, y: 360, target: 'output', label: 'IN' } }
    end
  end
end
