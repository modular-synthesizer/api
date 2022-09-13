module Modusynth
  module Decorators
    class Parameter < Draper::Decorator
      delegate_all

      def to_h
        {
          name: object.name,
          value: object.default,
          targets: object.targets,
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