FactoryBot.define do
  factory :empty_generator, class: Modusynth::Models::Tools::Generator do
    factory :generator do
      name { 'test_generator' }
      code { 'test code to execute();' }
    end
  end
end