module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class InnerNodes
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build name: nil, generator: nil, **others
          Modusynth::Models::Tools::InnerNode.new(name:, generator:)
        end

        def validate! prefix: nil, generator: nil, name: nil, **others
          build(generator:, name:).validate!
        end
      end
    end
  end
end
