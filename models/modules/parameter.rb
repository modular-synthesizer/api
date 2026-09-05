# frozen_string_literal: true

module Modusynth
  module Models
    module Modules
      # This represents the value a module has given to a parameter declared in its
      # blueprint descriptor. The value will be replacing the
      class Parameter
        include Mongoid::Document
        include Modusynth::Models::Concerns::Parameter

        store_in collection: 'parameters'

        field :value, type: Float

        embedded_in :module, class_name: '::Modusynth::Models::Module', inverse_of: :value
      end
    end
  end
end
