module Modusynth
  module Decorators
    class Tool < Draper::Decorator
      delegate_all

      def to_h
        {
          id: id.to_s,
          name: name,
          slots: slots,
          innerNodes: inner_nodes
        }
      end

      def inner_nodes
        object.inner_nodes.map do |node|
          {
            id: node.id.to_s,
            name: node.name,
            factory: node.factory
          }
        end
      end
    end
  end
end