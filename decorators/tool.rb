# frozen_string_literal: true

module Modusynth
  module Decorators
    class Tool < Draper::Decorator
      delegate_all

      def to_h
        {
          id: id.to_s,
          name:,
          slots:,
          nodes: inner_nodes,
          links: inner_links,
          parameters:,
          ports: ports.map do |port|
            {
              id: port.id,
              name: port.name,
              kind: port.kind,
              index: port.index,
              target: port.target
            }
          end,
          category: Category.new(object.category).to_h,
          controls: object.controls.map do |control|
            {
              id: control.id.to_s,
              payload: control.payload,
              component: control.component
            }
          end
        }
      end

      def to_simple_h
        {
          id: id.to_s,
          name:,
          slots:
        }
      end

      def inner_nodes
        object.inner_nodes.map do |node|
          {
            id: node.id.to_s,
            name: node.name,
            generator: node.generator
          }
        end
      end

      def inner_links
        object.inner_links do |link|
          {
            id: link.id.to_s,
            from: {
              node: link.from.node,
              index: link.from.index
            },
            to: {
              node: link.to.node,
              index: link.to.index
            }
          }
        end
      end

      def parameters
        object.parameters.map do |param|
          descriptor = Modusynth::Decorators::Parameter.new(param).to_h
          descriptor.merge({targets: param.targets})
        end
      end
    end
  end
end
