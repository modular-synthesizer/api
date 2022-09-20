module Modusynth
  module Models
    class Link
      include Mongoid::Document

      field :color, type: String

      belongs_to :from, class_name: '::Modusynth::Models::Modules::Port'

      belongs_to :to, class_name: '::Modusynth::Models::Modules::Port'

      belongs_to :synthesizer, class_name: '::Modusynth::Models::Synthesizer'
    end
  end
end