module Modusynth
  module Services
    class Modules < Modusynth::Services::Base
      include Singleton
      include Modusynth::Services::Concerns::Deleter

      def build synthesizer_id: nil, tool_id: nil, slot: 0, rack: 0, **_
        synthesizer = Modusynth::Services::Synthesizers.instance.find_or_fail(
          id: synthesizer_id,
          field: 'synthesizer_id'
        )
        tool = Modusynth::Services::Tools::Find.instance.find_or_fail(id: tool_id)
        model.new(synthesizer:, tool:, slot:, rack:)
      end

      def list(synthesizer_id:, **_)
        model.where(synthesizer_id:).to_a
      end

      def update id, payload
        attributes = payload.slice('slot', ('rack'))
        node = find_or_fail(id:)
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

      def delete mod
        ports_ids = mod.ports.map(&:id).map(&:to_s)
        Modusynth::Models::Link.where(:from.in => ports_ids).delete_all
        Modusynth::Models::Link.where(:to.in => ports_ids).delete_all
        mod.parameters.delete_all
        mod.ports.delete_all
        mod.delete
      end

      def model
        Modusynth::Models::Module
      end
    end
  end
end