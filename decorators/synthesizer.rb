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
          nodes: object.modules.map do |node|
            Modusynth::Decorators::Module.new(node).to_h
          end
        }
      end
    end
  end
end