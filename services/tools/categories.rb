module Modusynth
  module Services
    module Tools
      class Categories
        include Singleton
        include Modusynth::Services::Concerns::Finder

        def model
          Modusynth::Models::Category
        end
      end
    end
  end
end
