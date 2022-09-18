module Modusynth
  module Decorators
    class Synthesizer < Draper::Decorator
      delegate_all

      def to_simple_h
        {
          id: object.id.to_s,
          name: object.name
        }
      end

      def to_h
        {
          id: object.id.to_s,
          name: object.name,
          slots: object.slots,
          racks: object.racks,
          x: object.x,
          y: object.y,
          scale: object.scale
        }
      end
    end
  end
end