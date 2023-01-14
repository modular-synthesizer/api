# frozen_string_literal: true

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
          nodes: tool.inner_nodes,
          links: tool.inner_links,
          parameters: parameters,
          inputs: ports(object.ports.inputs),
          outputs: ports(object.ports.outputs),
          type: tool.name,
          category: tool.category.nil? ? 'tools' : tool.category.name,
          controls: tool.controls.map do |control|
            {
              id: control.id.to_s,
              payload: control.payload,
              component: control.component
            }
          end
        }
      end

      def parameters
        object.parameters.map do |instance|
          {
            id: instance.id.to_s,
            value: instance.value,
            name: instance.parameter.name,
            field: instance.parameter.descriptor.field,
            input: { id: instance.parameter.id.to_s },
            targets: instance.parameter.targets,
            constraints: {
              minimum: instance.parameter.descriptor.minimum,
              maximum: instance.parameter.descriptor.maximum,
              step: instance.parameter.descriptor.step,
              precision: instance.parameter.descriptor.precision
            }
          }
        end
      end

      def ports(list)
        list.map do |port|
          {
            id: port.id.to_s,
            name: port.descriptor.name,
            target: port.descriptor.target,
            index: port.descriptor.index
          }
        end
      end
    end
  end
end
