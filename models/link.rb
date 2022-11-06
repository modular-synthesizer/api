module Modusynth
  module Models
    class Link
      include Mongoid::Document

      store_in collection: 'links'

      field :color, type: String
      
      field :to, type: String
      
      field :from, type: String

      belongs_to :synthesizer, class_name: '::Modusynth::Models::Synthesizer'
    end
  end
end