module Modusynth
  module Models
    module Tools
      # The representation of one of the Web Audio API node embedded
      # inside a module in a synthesizer. The type show how it will
      # be created by the frontend part.
      class InnerNode
        include Mongoid::Document

        field :name, type: String
        
        field :generator, type: String

        # @!attribute [rw] x
        #   @return [Integer] the X coordinate of the graphical representation of the node.
        field :x, type: Integer, default: 0
        # @!attribute [rw] y
        #   @return [Integer] the Y coordinate of the graphical representation of the node.
        field :y, type: Integer, default: 0

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }
        
        validates :generator,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :generator? }
        
        embedded_in :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :inner_nodes
      end
    end
  end
end