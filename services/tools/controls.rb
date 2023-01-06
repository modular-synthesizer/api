module Modusynth
  module Services
    module Tools
      class Controls
        include Singleton
        include Modusynth::Services::Concerns::Creator

        def build component:, payload:, **rest
          Modusynth::Models::Tools::Control.new(component:, payload:)
        end

        def validate! component:, payload:, **rest
          build(component:, payload:, **rest).validate!
        end
      end
    end
  end
end