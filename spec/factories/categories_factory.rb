FactoryBot.define do
  factory :category, class: ::Modusynth::Models::Category do
    factory :dopefun do
      name { 'dopefun' }
    end
  end
end