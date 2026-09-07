FactoryBot.define do
  factory :empty_control, class: Modusynth::Models::Blueprints::ControlTemplate do
    factory :knob do
      component { 'Knob' }
    end
    factory :button do
      component { 'Button' }
    end
  end
end
