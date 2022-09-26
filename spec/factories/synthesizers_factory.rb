FactoryBot.define do
  factory :synthesizer, class: Modusynth::Models::Synthesizer do
    name { 'test synth' }
    association :account, factory: :babausse
  end
end