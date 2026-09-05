FactoryBot.define do
  factory :parameter, class: Modusynth::Models::Blueprints::ParameterTemplate do
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

  factory :parameter_instance, class: Modusynth::Models::Modules::Parameter do
    factory :frequency_instance do
      name { 'freqparam' }
      field { 'frequency' }
      targets { ['node1'] }
    end
  end
end
