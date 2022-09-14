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