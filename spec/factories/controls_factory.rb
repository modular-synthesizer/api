FactoryBot.define do
  factory :empty_control, class: Modusynth::Models::Tools::Control do
    factory :knob do
      component { 'Knob' }
    end
  end
end