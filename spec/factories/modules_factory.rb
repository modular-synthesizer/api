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

    # A fully-functional VCO to test the new synthesizer route. It implements most of the cases,
    # like a port linked to several inner audio WAA node, or a parameter linked to several audio
    # WAA parameters.
    factory :vco_module do
      name { 'VCO' }
      association :blueprint, factory: :vco_blueprint
    end
  end
end
