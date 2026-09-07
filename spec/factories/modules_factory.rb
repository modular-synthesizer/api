FactoryBot.define do
  factory :module, class: Modusynth::Models::Module do
    factory :VCA_module do
      association :synthesizer, factory: :synthesizer
      association :blueprint, factory: :VCA
      after :create do |mod|
        mod.ports = [
          build(:input_port_instance, name: 'INPUT', target: 'gain'),
          build(:output_port_instance, name: 'OUTPUT', target: 'gain')
        ]
      end
    end
  end
end
