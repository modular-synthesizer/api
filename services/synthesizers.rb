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

      def create payload
        payload = payload.slice('name', 'slots', 'racks')
        synthesizer = Modusynth::Models::Synthesizer.new(**payload)
        synthesizer.save!
        synthesizer
      end

      def update id, payload
        payload = payload.slice('x', 'y', 'scale')
        synth = find_or_fail(id)
        synth.update **payload
        synth
      end

      def delete id
        synth = Modusynth::Models::Synthesizer.find(id)
        unless synth.nil?
          synth.modules.delete_all
          synth.delete
        end
      end
    end
  end
end