module Modusynth
  module Decorators
    class Synthesizer < Draper::Decorator
      delegate_all

      def to_h
        {
          id: object.id.to_s,
          name: object.name
        }
      end
    end
  end
end