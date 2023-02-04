FactoryBot.define do
  factory :empty_port, class: Modusynth::Models::Tools::Port do
    target { 'node_target' }
    index { 0 }
    factory :input_port do
      kind { 'input' }
      name { 'INPUT' }
    end
    factory :output_port do
      kind { 'output' }
      name { 'OUTPUT' }
    end
  end
end