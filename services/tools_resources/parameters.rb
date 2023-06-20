module Modusynth
  module Services
    module ToolsResources
      class Parameters < Modusynth::Services::Base
        include Singleton

        def build name: nil, targets: [], descriptorId: nil, tool: nil, prefix: '', **others
          descriptor = Descriptors.instance.find_or_fail(id: descriptorId, field: 'descriptorId')
          parameter = model.new(name:, targets:, descriptor:, tool:)
          tool.modules.each do |mod|
            mod.parameters << Modusynth::Models::Modules::Parameter.new(
              parameter:,
              value: parameter.descriptor.default
            )
          end
          parameter
        end
        
        def update port, **payload
          delete_links = [:target, :kind, :index].any? do |field|
            # The to_s here is given because params return a string index, not an integer
            payload.key?(field) && payload[field] != port[field].to_s
          end
          port.update(payload.slice(:name, :target, :kind, :index))
          if delete_links && port.valid?
            Modusynth::Models::Modules::Port.where(descriptor: port).each do |mod_port|
              mod_ports_service.delete_links mod_port
            end
          end
          port
        end

        def validate! **payload
          build(**payload).validate!
        end

        def delete descriptor
          Modusynth::Models::Modules::Port.where(descriptor:).each do |mod_port|
            mod_ports_service.remove(id: mod_port.id)
          end
          descriptor.delete
        end

        def model
          Modusynth::Models::Tools::Parameter
        end

        def mod_ports_service
          Modusynth::Services::Ports.instance
        end
      end
    end
  end
end
