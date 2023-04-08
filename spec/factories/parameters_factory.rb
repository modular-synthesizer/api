FactoryBot.define do
  factory :parameter, class: Modusynth::Models::Tools::Parameter do
    association :tool, factory: :tool
    factory :frequency do
      association :descriptor, factory: :frequency_descriptor
      name { 'freqparam' }
    end
    factory :gain do
      association :descriptor, factory: :gain_descriptor
      name { 'gainparam' }
    end
  end
end