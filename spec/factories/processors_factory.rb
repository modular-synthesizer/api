FactoryBot.define do
  factory :empty_processor, class: ::Modusynth::Models::AudioProcessor do
    factory :audio_processor do
      process_function { 'return true;' }
    end
  end
end