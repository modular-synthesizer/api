module Modusynth
  module Models
    module Modules
      # This represents the value a module has given to a parameter declared in its
      # tool descriptor. The value will be replacing the 
      class Value
        include Mongoid::Document

        field :name, type: String

        field :value, type: Float

        embedded_in :module, class_name: '::Modusynth::Models::Module', inverse_of: :value
      end
    end
  end
end