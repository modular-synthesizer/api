# frozen_string_literal: true

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
        include Mongoid::Document

        store_in collection: 'tools_controls'

        # @!attribute [rw] payload
        #   @return [Hash] the attributes passed to the component as props. If an attribute is not defined, the default
        #     value for this key will be used on the client side.
        field :payload, type: Hash, default: {}

        belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :controls

        belongs_to :component, class_name: '::Modusynth::Models::Tools::Component', inverse_of: :controls

        validate :payload_validation

        # Validates that the payload respects the constraints of the corresponding component.
        # It will raise an error if :
        # * a key is given with the wrong type (string when it should be a number).
        # * a key is not given when it should be in the payload.
        def payload_validation
          return true if component.nil?

          component.variables.each do |variable|
            check_existence variable.name
            check_type variable.name, variable.type
          end
        end

        def check_existence(name)
          errors.add(:"payload.\#{name}", 'required') unless payload.key?(name.to_sym)
        end

        def check_type(name, type)
          case type
          when :string
            errors.add(:"payload.\#{name}", 'type') unless payload[name.to_sym].is_a?(String)
          when :number
            errors.add(:"payload.\#{name}", 'type') unless payload[name.to_sym].is_a?(Numeric)
          end
        end
      end
    end
  end
end
