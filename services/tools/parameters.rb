module Modusynth
  module Services
    module Tools
      # This service allow for the creation of inner nodes in tools.
      class Parameters < Modusynth::Services::Base
        include Singleton

        def build descriptorId: nil, targets: [], name: nil, **rest
          descriptor = Descriptors.instance.find_or_fail(id: descriptorId, field: 'descriptorId')
          model.new(descriptor_id: descriptorId, targets:, name:)
        end

        def validate! descriptorId: nil, targets: [], name: nil, prefix: nil, **rest
          if descriptorId.nil?
            raise Modusynth::Exceptions::Service.new(key: 'descriptorId', prefix:, error: 'required')
          end
          build(descriptorId:, targets:, name:).validate!
        end

        def delete descriptor, **_
          descriptor.tool.modules.each do |mod|
            mod.parameters.where(parameter: descriptor).all.delete
          end
          descriptor.delete
        end

        def model
          Modusynth::Models::Tools::Parameter
        end
      end
    end
  end
end