module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class InnerNodes
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build name: nil, generator: nil
          Modusynth::Models::Tools::InnerNode.new(name:, generator:)
        end
      end
    end
  end
end