module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class InnerNodes
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build name: nil, generator: nil, x: 0, y: 0, **others
          Modusynth::Models::Tools::InnerNode.new(name:, generator:, x:, y:)
        end

        def validate! prefix: nil, generator: nil, name: nil, x: 0, y: 0, **others
          build(generator:, name:, x:, y:).validate!
        end
      end
    end
  end
end
