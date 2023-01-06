module Modusynth
  module Services
    module Tools
      class Descriptors
        include Singleton
        include Modusynth::Services::Concerns::Finder

        def model
          Modusynth::Models::Tools::Descriptor
        end
      end
    end
  end
end