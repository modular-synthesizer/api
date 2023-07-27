FactoryBot.define do
  factory :synthesizer, class: Modusynth::Models::Synthesizer do
    name { 'test synth' }
  end

  factory :membership, class: Modusynth::Models::Social::Membership do

  end
end