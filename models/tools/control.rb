module Modusynth
  module Models
    module Tools
      # A control represents a component displayed on screen inside a module. Controls are declared on tools as they are
      # the same for all modules created from the same tool. They can target a parameter, but are not forced to do so.
      # A component not targeting a parameter can, for example, be just a label or a frame in the module. A component
      # targeting a parameter can for example be a knob, or a screen displaying in.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Control
        # @!attribute [rw] component
        #   @return [String] the name of the component, on the client-side, used to render this control.
        field :component, type: String
        # @!attribute [rw] payload
        #   @return [Hash] the attributes passed to the component as props. If an attribute is not defined, the default
        #     value will be used on the client side to 
        field :payload, type: Hash, default: {}
      end
    end
  end
end