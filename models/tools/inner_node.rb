module Modusynth
  module Models
    module Tools
      # The representation of one of the Web Audio API node embedded
      # inside a module in a synthesizer. The type show how it will
      # be created by the frontend part.
      class InnerNode
        include Mongoid::Document

        # @!attribute [rw] name
        #   @return [String] the name of the inner node, not neceesarily uniq, usef to reference it in links/ports/parameters.
        field :name, type: String
        # @!attribute [rw] generator
        #   @return [String] the name of the generator used to build this inner node.
        field :generator, type: String
        # @!attribute [rw] polyphonic
        #   @return [Boolean] TRUE if the node is meant to be duplicated for polyphony, FALSE otherwise.
        field :polyphonic, type: Boolean, default: false

        # @!attribute [rw] x
        #   @return [Integer] the X coordinate of the graphical representation of the node.
        field :x, type: Integer, default: 0
        # @!attribute [rw] y
        #   @return [Integer] the Y coordinate of the graphical representation of the node.
        field :y, type: Integer, default: 0

        def generator_object
          Modusynth::Models::Tools::Generator.find_by(name: generator)
        end

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