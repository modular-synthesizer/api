module Modusynth
  module Models
    module Tools
      # A generator is the code of a javascript function that can be executed to create an AudioNode type
      # They will be instanciated in the frontend when creating inner nodes in audio modules.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Generator
        include Mongoid::Document
        
        store_in collection: 'generators'

        # @!attribute [rw] name
        #   @return [String] the name of the generator, used in inner links to identify their type.
        field :name, type: String
        # @!attribute [rw] code
        #   @return [String] the code executed when instanciating this generator.
        field :code, type: String
        # @!attribute [rw] parameters
        #   @eturn [String] the JSON encoded object containing the parameters of the generator
        field :parameters, type: Array, default: []
        # @!attribute [rw] inputs
        #   @return [Integer] the number of input ports available in the generated node
        field :inputs, type: Integer, default: 1
        # @!attribute [rw] outputs
        #   @return [Integer] the number of output ports available in the generated node
        field :outputs, type: Integer, default: 1

        validates :name, presence: { message: 'required' }

        validates :code, presence: { message: 'required' }

        validates :inputs, numericality: { greater_than: 0, message: 'value' }

        validates :outputs, numericality: { greater_than: 0, message: 'value' }

        def complete_code
          /^[a-zA-Z]+$/.match(self.code) ? "return new #{code}(context, payload);" : self.code
        end
      end
    end
  end
end