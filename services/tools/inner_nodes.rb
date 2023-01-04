module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class InnerNodes
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build name: nil, generator: nil, **others
          model.new(name:, generator:)
        end

        def validate! prefix:, generator:, name:, **others
          model.new(generator:, name:).validate!
        end

        private

        def model
          Modusynth::Models::Tools::InnerNode
        end
      end
    end
  end
end