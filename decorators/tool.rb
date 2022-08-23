module Modusynth
  module Decorators
    class Tool < Draper::Decorator
      delegate_all

      def to_h
        {
          id: id.to_s,
          name: name,
          slots: slots,
          inner_nodes: inner_nodes
        }
      end

      def inner_nodes
        object.inner_nodes.map do |node|
          {
            name: node.name,
            type: node.type,
            payload: node.payload
          }
        end
      end
    end
  end
end