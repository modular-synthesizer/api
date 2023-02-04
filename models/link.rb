module Modusynth
  module Models
    class Link
      include Mongoid::Document

      store_in collection: 'links'

      field :color, type: String

      belongs_to :synthesizer, class_name: '::Modusynth::Models::Synthesizer'

      belongs_to :from, class_name: '::Modusynth::Models::Module'

      belongs_to :to, class_name: '::Modusynth::Models::Module'
    end
  end
end