module Modusynth
  module Services
    module Tools
      class Controls < Modusynth::Services::Base
        include Singleton

        def build component: nil, payload: {}, **rest
          Modusynth::Models::Tools::Control.new(component:, payload:)
        end

        def validate! component: nil, payload: {}, **rest
          build(component:, payload:, **rest).validate!
        end

        def model
          Modusynth::Models::Tools::Control
        end
      end
    end
  end
end