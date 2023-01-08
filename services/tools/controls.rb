module Modusynth
  module Services
    module Tools
      class Controls
        include Singleton
        include Modusynth::Services::Concerns::Creator

        def build component: nil, payload: {}, **rest
          Modusynth::Models::Tools::Control.new(component:, payload:)
        end

        def validate! component: nil, payload: {}, **rest
          build(component:, payload:, **rest).validate!
        end
      end
    end
  end
end