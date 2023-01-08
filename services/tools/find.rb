module Modusynth
  module Services
    module Tools
      class Find
        include Singleton
        include Modusynth::Services::Concerns::Finder

        def model
          Modusynth::Models::Tool
        end
      end
    end
  end
end