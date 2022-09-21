module Modusynth
  module Services
    class Links
      include Singleton

      def list params
        params = params.slice(:synthesizer_id)
        Modusynth::Models::Link.where(**params)
      end

      def create payload
        payload = payload.slice('from', 'to', 'synthesizer_id', 'color')

        link = Modusynth::Models::Link.new(
          from: payload['from'],
          to: payload['to'],
          color: payload['color'],
          synthesizer: find_synth(payload['synthesizer_id'])
        )
        link.save!
        link
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

      def find_synth id
        Modusynth::Models::Synthesizer.find(id)
      end
    end
  end
end