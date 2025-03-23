FactoryBot.define do
  factory :component, class: Modusynth::Models::Tools::Component do
    component_name { 'TestComponent' }
  end

  factory :empty_control, class: Modusynth::Models::Tools::Control do
    factory :knob do
      before(:create) do |control|
        control.component = build(:component)
      end
    end
    factory :button do
      component { 'Button' }
    end
  end
end
