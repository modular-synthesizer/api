module Modusynth
  module Decorators
    class Parameter < Draper::Decorator
      delegate_all

      def to_h
        {
          id: object.id.to_s,
          name: object.name,
          value: object.default,
          constraints: {
            minimum: object.minimum,
            maximum: object.maximum,
            step: object.step,
            precision: object.precision
          }
        }
      end
    end
  end
end