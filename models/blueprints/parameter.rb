# frozen_string_literal: true

module Modusynth
  module Models
    module Blueprints
      # A parameter represents a value of an AudioParam in the client-side application. It links a descriptor setting
      # constraints for the value of the parameter, and a set of targets being inner nodes of the blueprint the
      # parameter is declared into. After being instanciated, each blueprint parameter will generate a module
      # parameter.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class ParameterTemplate
        include Mongoid::Document
        include Modusynth::Models::Blueprints::Parameter

        store_in collection: 'parameter_templates'
      end
    end
  end
end
