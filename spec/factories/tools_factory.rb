FactoryBot.define do
  factory :inner_node, class: Modusynth::Models::Tools::InnerNode do
    factory :gain_node do
      name { 'gain' }
      generator { 'GainNode' }
    end
  end
  factory :port, class: Modusynth::Models::Tools::Port do
  index { 0 }
  end
  factory :tool, class: Modusynth::Models::Tool do
    name { 'test tool' }
    slots { 5 }
    factory :VCA do
      name { 'VCA' }
      slots { 3 }
      after(:create) do |tool|
        create_list(:gain_node, 1, tool: tool)
        create_list(:gain, 1, tool: tool, targets: ['gain'])
        tool.inputs = [build(:port, name: 'INPUT', targets: ['gain'])]
        tool.outputs = [build(:port, name: 'OUTPUT', targets: ['gain'])]
        tool.save!
      end
    end
  end
end