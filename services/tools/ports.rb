module Modusynth
  module Services
    module Tools
      class Ports
        include Singleton
        include Modusynth::Services::Concerns::Creator

        def build kind: nil, name: nil, target: nil, index: nil, **others
          Modusynth::Models::Tools::Port.new(kind:, name:, target:, index:)
        end

        def validate! **payload
          build(**payload).validate!
        end
      end
    end
  end
end
