module Modusynth
  module Services
    class Links < Modusynth::Services::Base
      include Singleton

      def list params
        params = params.slice(:synthesizer_id)
        Modusynth::Models::Link.where(**params)
      end

      def build from: nil, to: nil, synthesizer_id: nil, color: 'red', session: nil, **_
        synthesizer = Synthesizers.instance.find_or_fail(id: synthesizer_id, field: 'synthesizer_id')
        membership = Memberships.instance.find_or_fail_by(synthesizer:, session:)
        raise Modusynth::Exceptions.forbidden('auth_token') if membership.type_read?
        from = Ports.instance.find_or_fail(id: from, synthesizer:, field: 'from')
        to = Ports.instance.find_or_fail(id: to, synthesizer:, field: 'to')
        link = Modusynth::Models::Link.new(from:, to:, color:, synthesizer:)
        link
      end

      def validate!(from: nil, to: nil, synthesizer_id: nil, color: 'red', session: nil, **_)
        instance = build(synthesizer_id:, from:, to:, color:, session:)
        if instance.from.kind == instance.to.kind
          raise Modusynth::Exceptions::BadRequest.new('directions', 'identical')
        end
        instance
      end

      def update id, payload
        payload = payload.slice('color')
        link = find_or_fail(id)
        link.update(**payload)
        link
      end

      def model
        Modusynth::Models::Link
      end
    end
  end
end