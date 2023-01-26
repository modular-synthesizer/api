module Modusynth
  module Services
    class Base
      include Modusynth::Services::Concerns::Creator
      include Modusynth::Services::Concerns::Deleter
      include Modusynth::Services::Concerns::Finder
      include Modusynth::Services::Concerns::Updater

      def model
        raise Modusynth::Exceptions::Service.new(
          key: 'model',
          error: 'not_implemented',
          status: 500
        )
      end
    end
  end
end