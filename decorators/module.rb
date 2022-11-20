module Modusynth
  module Decorators
    class Module < Draper::Decorator
      delegate_all

      attr_reader :tool

      def initialize(item)
        super(item)
        @tool = Modusynth::Decorators::Tool.new(object.tool)
      end

      def to_h
        {
          id: object.id.to_s,
          slot: object.slot,
          slots: object.tool.slots,
          rack: object.rack,
          innerNodes: tool.inner_nodes,
          innerLinks: tool.inner_links,
          parameters: parameters,
          inputs: ports(object.ports.inputs),
          outputs: ports(object.ports.outputs),
          type: tool.name
        }
      end

      def parameters
        object.parameters.map do |instance|
          {
            id: instance.id.to_s,
            value: instance.value,
            name: instance.parameter.name,
            input: { id: instance.parameter.id.to_s },
            targets: instance.parameter.targets,
            constraints: {
              minimum: instance.parameter.descriptor.minimum,
              maximum: instance.parameter.descriptor.maximum,
              step: instance.parameter.descriptor.step,
              precision: instance.parameter.descriptor.precision
            },
            x: instance.parameter.x || 0,
            y: instance.parameter.y || 0,
            component: instance.component
          }
        end
      end

      def ports list
        list.map do |port|
          {
            id: port.id.to_s,
            name: port.descriptor.name,
            target: port.descriptor.target,
            index: port.descriptor.index,
            x: port.descriptor.x || 0,
            y: port.descriptor.y || 0
          }
        end
      end
    end
  end
end