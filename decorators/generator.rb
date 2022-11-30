module Modusynth
  module Decorators
    class Generator < Draper::Decorator
      def to_h
        {
          name: object.name,
          code: object.code
        }
      end
    end
  end
end
    