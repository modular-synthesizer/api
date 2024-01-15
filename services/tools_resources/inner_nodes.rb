# frozen_string_literal: true

module Modusynth
  module Services
    module ToolsResources
      class InnerNodes < Modusynth::Services::Base
        include Singleton

        def build name: nil, generator: nil, x: 0, y: 0, polyphonic: false, tool: nil, **_
          model.new(name:, generator:, x:, y:, tool:, polyphonic:)
        end

        def validate! **payload
          build(**payload).validate!
        end

        def model
          Modusynth::Models::Tools::InnerNode
        end
      end
    end
  end
end
