FactoryBot.define do
  factory :empty_processor, class: ::Modusynth::Models::AudioProcessor do
    factory :audio_processor do
      url { 'https://www.example.com/processor.js' }
    end
  end
end