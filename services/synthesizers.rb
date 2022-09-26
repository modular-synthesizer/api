module Modusynth
  module Services
    class Synthesizers
      include Singleton

      def list
        Modusynth::Models::Synthesizer.all.to_a
      end

      def find_or_fail id, field = 'id'
        synthesizer = Modusynth::Models::Synthesizer.find(id)
        raise Modusynth::Exceptions.unknown(field) if synthesizer.nil?
        synthesizer
      end

      def create payload, auth_session
        payload = payload.slice('name', 'slots', 'racks')
        synthesizer = Modusynth::Models::Synthesizer.new(
          account: auth_session.account,
          **payload
        )
        synthesizer.save!
        synthesizer
      end

      def update synthesizer, payload
        synthesizer.update(**payload.slice('x', 'y', 'scale'))
        synth
      end

      def delete synthesizer
        synthesizer.modules.delete_all
        synthesizer.delete
      end
    end
  end
end