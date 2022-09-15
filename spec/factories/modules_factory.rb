FactoryBot.define do
  factory :module, class: Modusynth::Models::Module do
    factory :VCA_module do
      association :synthesizer, factory: :synthesizer
      association :tool, factory: :VCA
    end
  end
end