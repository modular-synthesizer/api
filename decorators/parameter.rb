# frozen_string_literal: true

module Modusynth
  module Decorators
    class Parameter < Draper::Decorator
      delegate_all

      def to_h
        {
          id: object.id.to_s,
          name: object.name,
          value: object.descriptor.default,
          constraints: {
            minimum: object.descriptor.minimum,
            maximum: object.descriptor.maximum,
            step: object.descriptor.step,
            precision: object.descriptor.precision
          }
        }
      end
    end
  end
end
