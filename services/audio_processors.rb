module Modusynth
  module Services
    class AudioProcessors < Modusynth::Services::Base
      def model
        ::Modusynth::Models::AudioProcessor
      end

      def build account: nil, url: nil, public: false, **_
        model.new(url:, public:, account:)
      end
    end
  end
end
