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

      def update id, values
        instance = find_or_fail(id)
        fields = instance.tool.parameters.map(&:descriptor).map(&:name)
        values.keys.each do |field|
          raise Modusynth::Exceptions::BadRequest.new(field, 'unknown') unless fields.include?(field)
          instance.values.where(name: field).first.update(value: values[field])
        end
        instance.save!
        instance
      end

      def find_or_fail(id)
        instance = Modusynth::Models::Module.find(id)
        raise Modusynth::Exceptions.unknown('id') if instance.nil?
      instance
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