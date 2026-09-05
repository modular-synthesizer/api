# frozen_string_literal: true

module Modusynth
  module Models
    module Modules
      # Instanciation of a port from its schema in the blueprint the module has been
      # created from. The instanciation will be used in the links.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Port
        include Mongoid::Document
        include Modusynth::Models::Concerns::Port

        store_in collection: 'ports'

        embedded_in :module, class_name: '::Modusynth::Models::Module', inverse_of: :ports
      end
    end
  end
end
