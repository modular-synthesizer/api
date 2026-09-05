# frozen_string_literal: true

module Modusynth
  module Models
    module Blueprints
      # This represents a pluggable port in the module. This is NOT representing the control displayed on the screen,
      # but the port itself, and the possibility to plug a link in, with where the link will be internally plugged.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class PortTemplate
        include Mongoid::Document
        include Modusynth::Models::Concerns::Port

        store_in collection: 'port_templates'

        # @!attribute [rw] blueprint
        #   @return [Modusynth::Models::Blueprints::Blueprint] the blueprint in which the port is declared.
        embedded_in :blueprint, class_name: '::Modusynth::Models::Blueprints::Blueprint', inverse_of: :ports,
                                optional: true
      end
    end
  end
end
