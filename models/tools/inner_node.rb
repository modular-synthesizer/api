module Modusynth
  module Models
    module Tools
      # The representation of one of the Web Audio API node embedded
      # inside a module in a synthesizer. The type show how it will
      # be created by the frontend part.
      class InnerNode
        include Mongoid::Document

        field :name, type: String

        field :factory, type: String

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }
        
        validates :factory,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :factory? }
      end
    end
  end
end