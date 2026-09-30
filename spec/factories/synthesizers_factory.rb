FactoryBot.define do
  factory :synthesizer, class: Modusynth::Models::Synthesizer do
    name { 'test synth' }

    factory :full_synthesizer do
    end
  end

  factory :membership, class: Modusynth::Models::Social::Membership do
  end
end
