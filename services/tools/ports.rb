module Modusynth
  module Services
    module Tools
      class Ports < Modusynth::Services::Base
        include Singleton

        def build kind: nil, name: nil, target: nil, index: nil, tool: nil, **others
          descriptor = model.new(kind:, name:, target:, index:, tool:)
          tool.modules.each do |mod|
            mod.ports << Modusynth::Models::Modules::Port.new(descriptor:)
          end
          descriptor
        end

        def build_all_with(items, prefix: '', **payload)

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

        def view
          '_port'
        end
      end
    end
  end
end
