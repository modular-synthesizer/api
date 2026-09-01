FactoryBot.define do
  factory :inner_node, class: Modusynth::Models::Blueprints::InnerNode do
    factory :gain_node do
      name { 'gain' }
      generator { 'GainNode' }
    end
    factory :oscillator_node do
      name { 'oscillator' }
      generator { 'OscillatorNode' }
    end
  end
  factory :blueprint, class: Modusynth::Models::Blueprints::Blueprint do
    name { 'test blueprint' }
    slots { 5 }
    factory :VCA do
      name { 'VCA' }
      slots { 3 }
      after(:create) do |blueprint|
        create_list(:gain_node, 1, blueprint: blueprint)
        create_list(:oscillator_node, 1, blueprint: blueprint)
        create_list(:gain, 1, blueprint: blueprint, targets: ['gain'])
        blueprint.ports = [
          build(:input_port, name: 'INPUT', target: 'gain'),
          build(:output_port, name: 'OUTPUT', target: 'gain')
        ]
        blueprint.controls = [
          build(:knob, payload: {x: 0, y: 100, target: 'gainparam'})
        ]
        blueprint.save!
      end
    end
  end
end