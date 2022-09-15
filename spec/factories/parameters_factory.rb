FactoryBot.define do
  factory :descriptor, class: Modusynth::Models::Tools::Descriptor do
    factory :frequency_descriptor do
      name { 'frequency' }
      default { 440 }
      minimum { 20 }
      maximum { 2020 }
      precision { 0 }
      step { 1 }
    end
    factory :gain_descriptor do
      name { 'gain' }
      default { 1 }
      minimum { 0 }
      maximum { 10 }
      precision { 2 }
      step { 0.05 }
    end
  end
  factory :parameter, class: Modusynth::Models::Tools::Parameter do
    association :tool, factory: :tool
    factory :frequency do
      association :descriptor, factory: :frequency_descriptor
    end
    factory :gain do
      association :descriptor, factory: :gain_descriptor
    end
  end
end