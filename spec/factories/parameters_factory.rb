FactoryBot.define do
  factory :parameter, class: Modusynth::Models::Tools::Parameter do
    factory :frequency do
      name { 'freqparam' }
      field { 'frequency' }
      targets { ['node1'] }
    end
    factory :gain do
      name { 'gainparam' }
      field { 'gain' }
      targets { ['node1'] }
    end
  end
end