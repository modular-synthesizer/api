module Modusynth
  module Services
    class Modules
      include Singleton

      def create payload
        creation = Modusynth::Models::Module.new(
          synthesizer: synthesizer(payload['synthesizer_id']),
          tool: tool(payload['tool_id'])
        )
        creation.save!
        creation
      end

      def list(params)
        search = params.slice(:synthesizer_id)
        Modusynth::Models::Module.where(**search).to_a
      end

      def update id, values
        node = find_or_fail(id)
        values.each do |field, value|
          parameter = node.parameters.called(field)
          unless parameter.nil?
            template = node.tool.parameters.called(field).first
            if value < template.descriptor.minimum || value > template.descriptor.maximum
              raise Modusynth::Exceptions::BadRequest.new(field, 'value')
            end
            parameter.update(value: value)
          end
        end
        node.save!
        node
      end

      def find_or_fail(id)
        instance = Modusynth::Models::Module.find(id)
        raise Modusynth::Exceptions.unknown('id') if instance.nil?
        instance
      end

      def delete id
        node = Modusynth::Models::Module.find(id)
        node.delete unless node.nil?
      end

      private

      def synthesizer id
        Modusynth::Services::Synthesizers.instance.find_or_fail(id, 'synthesizer_id')
      end

      def tool id
        Modusynth::Services::Tools.instance.find_or_fail(id, 'tool_id')
      end
    end
  end
end