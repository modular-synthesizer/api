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
        synthesizer = Modusynth::Models::Synthesizer.new(
          name: payload['name']
        )
        synthesizer.save!
        synthesizer
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