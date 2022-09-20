module Modusynth
  module Decorators
    class Link < Draper::Decorator
      def to_h
        {
          id: object.id.to_s,
          color: object.color,
          from: object.from.id.to_s,
          to: object.to.id.to_s
        }
      end
    end
  end
end