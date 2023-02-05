module Modusynth
  module Services
    module Tools
      class Update < Modusynth::Services::Base
        include Singleton

        def update instance, **payload
          instance.update(payload.slice(:name, :slots))
          instance
        end

        def model
          Modusynth::Models::Tool
        end
      end
    end
  end
end
