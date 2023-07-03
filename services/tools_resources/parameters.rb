module Modusynth
  module Services
    module ToolsResources
      class Parameters < Modusynth::Services::Base
        include Singleton

        def build(
          name: nil,
          targets: [],
          tool: nil,
          field: nil,
          minimum: 0,
          maximum: 100,
          step: 1,
          precision: 0,
          default: 50,
          prefix: '',
          **_
        )
          template = model.new(name:, targets:, tool:, minimum:, maximum:, step:, precision:, field:, default:)
          tool.modules.each do |mod|
            mod.parameters << Modusynth::Models::Modules::Parameter.new(
              template:,
              value: template.default
            )
          end
          template
        end
        
        def update parameter, **payload
          parameter.update(payload.slice(:name, :targets))
          if payload.key? :descriptorId
            descriptor = Descriptors.instance.find_or_fail(id: payload[:descriptorId], field: 'descriptorId')
            parameter.update(descriptor:)
            parameter.instances.each do |ins|
              descriptor = parameter.descriptor
              # Clamps the value of the instanciated parameters to avoid illegal values in new descriptor
              ins.update(value: [descriptor.minimum, descriptor.maximum, ins.value].sort[1])
            end
          end
          parameter
        end

        def validate! **payload
          build(**payload).validate!
        end

        def delete parameter
          parameter.instances.each(&:delete)
          parameter.delete
        end

        def model
          Modusynth::Models::Tools::Parameter
        end
      end
    end
  end
end
