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
      end
    end
  end
end