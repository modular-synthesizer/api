# frozen_string_literal: true

module Modusynth
  module Services
    module ToolsResources
      class Controls < Modusynth::Services::Base
        include Singleton

        def build blueprint: nil, component: nil, payload: {}, **_
          model.new(blueprint:, component:, payload:)
        end

        def update control, **payload
          control.update(payload.slice(:component, :payload))
          control
        end

        def model
          Modusynth::Models::Blueprints::Control
        end
      end
    end
  end
end
