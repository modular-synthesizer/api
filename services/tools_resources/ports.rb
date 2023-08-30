module Modusynth
  module Services
    module ToolsResources
      class Ports < Modusynth::Services::Base
        include Singleton

        def build kind: nil, name: nil, target: nil, index: nil, tool: nil, **others
          descriptor = model.new(
            kind:,
            name:,
            target:,
            index:,
            tool:,
            ports: tool.modules.map do |mod|
              Modusynth::Models::Modules::Port.new(module: mod)
            end
          )
          descriptor
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
          Modusynth::Models::Tools::Port
        end

        def mod_ports_service
          Modusynth::Services::Ports.instance
        end
      end
    end
  end
end
