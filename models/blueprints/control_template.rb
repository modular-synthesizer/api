# frozen_string_literal: true

module Modusynth
  module Models
    module Blueprints
      # A control represents a component displayed on screen inside a module. Controls are declared on blueprints as
      # they are the same for all modules created from the same blueprint. They can target a parameter, but are not
      # forced to do so.
      # A component not targeting a parameter can, for example, be just a label or a frame in the module. A component
      # targeting a parameter can for example be a knob, or a screen displaying in.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class ControlTemplate
        include Mongoid::Document
        include Modusynth::Models::Concerns::Control

        embedded_in :blueprint, class_name: '::Modusynth::Models::Blueprints::Blueprint', inverse_of: :controls
      end
    end
  end
end
