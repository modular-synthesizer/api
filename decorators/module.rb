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
          synthesizer_id: object.synthesizer.id.to_s,
          name: object.tool.name,
          innerNodes: tool.inner_nodes,
          innerLinks: tool.inner_links,
          parameters: parameters,
          inputs: ports(tool.inputs),
          outputs: ports(tool.outputs)
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
            name: port.name,
            targets: port.targets,
            index: port.index
          }
        end
      end
    end
  end
end