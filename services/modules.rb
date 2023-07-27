module Modusynth
  module Services
    class Modules < Modusynth::Services::Base
      include Singleton

      def build synthesizer_id: nil, tool_id: nil, slot: 0, rack: 0, session: nil, **_
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

      def update id: nil, session: nil, parameters: [], **payload
        mod = find_or_fail(id:)
        membership = Memberships.instance.find_or_fail_by(session:, synthesizer: mod.synthesizer)
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.nil? or membership.type_read?

        attributes = payload.slice('slot', 'rack')
        mod.update(**attributes)
        parameters.each do |param|
          obj = mod.parameters.find(param[:id])
          obj.value = param[:value]
          template = obj.template
          if obj.value < template.minimum || obj.value > template.maximum
            raise Modusynth::Exceptions::BadRequest.new(template.name, 'value')
          end
          obj.save!
        end
        mod.save!
        mod
      end

      def delete mod
        ports_ids = mod.ports.map(&:id).map(&:to_s)
        Modusynth::Models::Link.where(:from.in => ports_ids).delete_all
        Modusynth::Models::Link.where(:to.in => ports_ids).delete_all
        mod.parameters.delete_all
        mod.ports.delete_all
        mod.delete
      end

      def remove(session:, id:, **_)
        mod = find(id:)
        return if mod.nil?
        membership = Memberships.instance.find_by(session:, synthesizer: mod.synthesizer)
        delete mod unless membership.nil? or membership.type_read?
      end

      def model
        Modusynth::Models::Module
      end
    end
  end
end