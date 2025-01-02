module Modusynth
  module Services
    module Tools
      class Update < Modusynth::Services::Base
        include Singleton

        def update instance, **payload
          instance.update(payload.slice(:name, :slots, :experimental, :x, :y))
          if payload.key?(:categoryId)
            category =  Modusynth::Services::Categories.instance.find_or_fail(id: payload[:categoryId])
            instance.update(category:)
          end
          instance
        end
        
        def model
          Modusynth::Models::Tool
        end
      end
    end
  end
end
