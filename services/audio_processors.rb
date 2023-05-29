module Modusynth
  module Services
    class AudioProcessors < Modusynth::Services::Base
      def model
        ::Modusynth::Models::AudioProcessor
      end

      def build account: nil, registration_name: nil, process_function: nil, public: false, **_
        model.new(registration_name:, process_function:, public:, account:)
      end

      # Gets an audio processor by its name and formats it as a Javascript file to give to the requester.
      # @param name [String] the registration name of the audio processor to query.
      def get_and_format id:, **_
        processor = find_or_fail(id:)
        name = processor.registration_name
        lines = processor.process_function.split("\n").map { |line| "    #{line}" }
        classname = name.split('-').map(&:capitalize).join

        return <<-CODE
class #{classname} extends AudioWorkletProcessor {
  process(inputs, outputs, parameters) {
#{lines.join("\n")}
    return true;
  }
}

registerProcessor("#{name}", #{classname});
CODE
      end
    end
  end
end
