FactoryBot.define do
  factory :tool, class: Modusynth::Models::Tool do
    factory :VCA do
      name { 'VCA' }
      slots { 3 }
    end
  end
end