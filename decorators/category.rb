module Modusynth
  module Decorators
    class Category < Draper::Decorator
      def to_h
        {
          id: object.id.to_s,
          name: object.name
        }
      end
    end
  end
end