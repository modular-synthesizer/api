module Modusynth
  module Services
    module ToolsResources
      class InnerLinkEnds < Modusynth::Services::Base
        include Singleton

        def build node: nil, index: 0, prefix: '', **_
          model.new(node:, index:)
        end

        def model
          Modusynth::Models::Tools::InnerLinkEnd
        end
      end
    end
  end
end