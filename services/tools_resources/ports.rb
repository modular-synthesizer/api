module Modusynth
  module Services
    module ToolsResources
      class Ports < Modusynth::Services::Base
        include Singleton

        def build kind: nil, name: nil, target: nil, index: nil, blueprint: nil, **others
          model.new(
            kind:,
            name:,
            target:,
            index:,
            blueprint:
          )
        end

        def remove_in_blueprint(blueprint: nil, id: nil, **_)
          blueprint.ports.find_by(id:)&.delete
        end

        def find_in_blueprint(blueprint: nil, id: nil, **_)
          raise Modusynth::Exceptions.required('id') if id.nil?

          parameter = blueprint.ports.find_by(id:)
          raise Modusynth::Exceptions.unknown('id') if parameter.nil?

          parameter
        end

        def update port, **payload
          port.update(payload.slice(:name, :target, :kind, :index))
          port.validate!
          port
        end

        def validate! **payload
          build(**payload).validate!
        end

        def delete(descriptor)
          Modusynth::Models::Modules::Port.where(descriptor:).each do |mod_port|
            mod_ports_service.remove(id: mod_port.id)
          end
          descriptor.delete
        end

        def model
          Modusynth::Models::Blueprints::PortTemplate
        end

        def mod_ports_service
          Modusynth::Services::Ports.instance
        end
      end
    end
  end
end
