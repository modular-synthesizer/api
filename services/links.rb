module Modusynth
  module Services
    class Links < Modusynth::Services::Base
      include Singleton

      def list params
        params = params.slice(:synthesizer_id)
        Modusynth::Models::Link.where(**params)
      end

      def build from: nil, to: nil, synthesizer_id: nil, color: 'red', **_
        synthesizer = Synthesizers.instance.find_or_fail(id: synthesizer_id, field: 'synthesizer_id')
        from = Ports.instance.find_or_fail(id: from, synthesizer:, field: 'from')
        to = Ports.instance.find_or_fail(id: to, synthesizer:, field: 'to')
        Modusynth::Models::Link.new(from:, to:, color:, synthesizer:)
      end

      def validate!(from: nil, to: nil, synthesizer_id: nil, color: 'red', session: nil, **_)
        instance = build(synthesizer_id:, from:, to:, color:)
        raise Modusynth::Exceptions.unknown('synthesizer_id') if instance.synthesizer.account.id != session.account.id
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

      def delete id
        find_or_fail(id).delete
      end

      def find_or_fail id
        link = Modusynth::Models::Link.find(id)
        raise Modusynth::Exceptions.unknown 'id' if link.nil?
        link
      end

      def model
        Modusynth::Models::Link
      end
    end
  end
end