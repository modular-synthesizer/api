module Modusynth
  module Services
    class Modules
      include Singleton

      def create payload
        creation = Modusynth::Models::Module.new(
          synthesizer: synthesizer(payload['synthesizer_id']),
          tool: tool(payload['tool_id']),
          slot: payload['slot'] || 0,
          rack: payload['rack'] || 0
        )
        creation.save!
        creation
      end

      def list(params)
        search = params.slice(:synthesizer_id)
        Modusynth::Models::Module.where(**search).to_a
      end

      def update id, payload
        attributes = payload.slice('slot', ('rack'))
        node = find_or_fail(id)
        node.update(**attributes)
        (payload['parameters'] || []).each do |param|
          obj = node.parameters.find(param['id'])
          obj.value = param['value']
          descriptor = obj.parameter.descriptor
          if obj.value < descriptor.minimum || obj.value > descriptor.maximum
            raise Modusynth::Exceptions::BadRequest.new(descriptor.name, 'value')
          end
          obj.save!
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
        unless node.nil?
          ports_ids = node.ports.map(&:id).map(&:to_s)
          Modusynth::Models::Link.where(:from.in => ports_ids).delete_all
          Modusynth::Models::Link.where(:to.in => ports_ids).delete_all
          node.parameters.delete_all
          node.ports.delete_all
          node.delete
        end
      end

      private

      def synthesizer id
        Modusynth::Services::Synthesizers.instance.find_or_fail(id, 'synthesizer_id')
      end

      def tool id
        Modusynth::Services::Tools::Find.instance.find_or_fail(id: id, field: 'tool_id')
      end
    end
  end
end