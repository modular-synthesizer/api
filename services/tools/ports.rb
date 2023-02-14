module Modusynth
  module Services
    module Tools
      class Ports < Modusynth::Services::Base
        include Singleton

        def build kind: nil, name: nil, target: nil, index: nil, **others
          model.new(kind:, name:, target:, index:)
        end

        def validate! **payload
          build(**payload).validate!
        end

        def delete descriptor
          Modusynth::Models::Modules::Port.where(descriptor:).each do |mod_port|
            Modusynth::Services::Ports.instance.remove(id: mod_port.id)
          end
          descriptor.delete
        end

        def model
          Modusynth::Models::Tools::Port
        end
      end
    end
  end
end
