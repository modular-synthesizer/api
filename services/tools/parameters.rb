module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class Parameters
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build descriptorId: nil, targets: [], **rest
          descriptor = Descriptors.instance.find_or_fail(id: descriptorId, field: 'descriptorId')
          Modusynth::Models::Tools::Parameter.new(descriptor_id: descriptorId, targets:)
        end

        def validate! descriptorId: nil, targets: [], prefix: nil, **rest
          if descriptorId.nil?
            raise Modusynth::Exceptions::Service.new(key: 'descriptorId', prefix:, error: 'required')
          end
          build(descriptorId:, targets:).validate!
        end
      end
    end
  end
end