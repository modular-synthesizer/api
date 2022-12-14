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
          innerNodes: inner_nodes,
          innerLinks: inner_links,
          parameters:,
          inputs: ports(object.inputs),
          outputs: ports(object.outputs)
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
          descriptor = Modusynth::Decorators::Parameter.new(param.descriptor).to_h
          descriptor.merge({
                             targets: param.targets,
                             x: param.x,
                             y: param.y,
                             component: param.component
                           })
        end
      end

      def ports(ports_list)
        ports_list.map do |port|
          { name: port.name, index: port.index, target: port.target, x: port.x, y: port.y }
        end
      end
    end
  end
end
