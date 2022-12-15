module Modusynth
  module Services
    module Permissions
      class Scopes
        include Singleton
        include Modusynth::Services::Concerns::Finder

        private

        def model
          Modusynth::Models::Permissions::Scope
        end
      end
    end
  end
end