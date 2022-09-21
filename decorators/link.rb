module Modusynth
  module Decorators
    class Link < Draper::Decorator
      def to_h
        {
          id: object.id.to_s,
          color: object.color,
          from: object.from,
          to: object.to
        }
      end
    end
  end
end