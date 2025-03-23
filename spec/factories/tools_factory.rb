FactoryBot.define do
  factory :inner_node, class: Modusynth::Models::Tools::InnerNode do
    factory :gain_node do
      name { 'gain' }
      generator { 'GainNode' }
    end
    factory :oscillator_node do
      name { 'oscillator' }
      generator { 'OscillatorNode' }
    end
  end
  factory :tool, class: Modusynth::Models::Tool do
    name { 'test tool' }
    slots { 5 }
    factory :VCA do
      name { 'VCA' }
      slots { 3 }
      after(:create) do |tool|
        create_list(:gain_node, 1, tool: tool)
        create_list(:oscillator_node, 1, tool: tool)
        create_list(:gain, 1, tool: tool, targets: ['gain'])
        tool.ports = [
          build(:input_port, name: 'INPUT', target: 'gain'),
          build(:output_port, name: 'OUTPUT', target: 'gain')
        ]
        tool.controls = [build(:knob)]
        tool.save!
      end
    end
  end
end
