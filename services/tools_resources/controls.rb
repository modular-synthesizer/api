# frozen_string_literal: true

module Modusynth
  module Services
    module ToolsResources
      class Controls < Modusynth::Services::Base
        include Singleton

        def build tool: nil, component: nil, payload: {}, **_
          model.new(tool:, component:, payload:)
        end

        def update control, **payload
          control.update(payload.slice(:component, :payload))
          control
        end

        def model
          Modusynth::Models::Tools::Control
        end
      end
    end
  end
end
