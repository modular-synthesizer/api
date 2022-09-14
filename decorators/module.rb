module Modusynth
  module Decorators
    class Module < Draper::Decorator
      delegate_all

      def to_h
        {
          id: object.id.to_s,
          synthesizer_id: object.synthesizer.id.to_s,
          name: object.tool.name
        }
      end
    end
  end
end