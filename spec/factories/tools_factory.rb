FactoryBot.define do
  factory :inner_node, class: Modusynth::Models::Tools::InnerNode do
    factory :gain_node do
      name { 'gain' }
      generator { 'GainNode' }
    end
  end
  factory :tool, class: Modusynth::Models::Tool do
    factory :VCA do
      name { 'VCA' }
      slots { 3 }
      after(:create) do |tool|
        create_list(:gain_node, 1, tool: tool)
      end
    end
  end
end