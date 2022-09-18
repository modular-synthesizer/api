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
        object.tool.parameters.map do |parameter|
          descriptor = Modusynth::Decorators::Parameter.new(parameter.descriptor).to_h
          descriptor.merge({targets: parameter.targets})
        end
      end

      def ports list
        list.map do |port|
          {
            id: port.id.to_s,
            name: port.descriptor.name,
            targets: port.descriptor.targets,
            index: port.descriptor.index
          }
        end
      end
    end
  end
end