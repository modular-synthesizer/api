module Modusynth
  module Services
    module ToolsResources
      class Parameters < Modusynth::Services::Base
        include Singleton

        def build(
          name: nil,
          targets: [],
          blueprint: nil,
          field: nil,
          minimum: 0,
          maximum: 100,
          step: 1,
          precision: 0,
          default: 50,
          **_
        )
          model.new(
            name:,
            targets:,
            blueprint:,
            minimum:,
            maximum:,
            step:,
            precision:,
            field:,
            default:
          )
        end

        def update parameter, **payload
          parameter.update(payload.slice(:name, :targets, :field, :minimum, :default, :maximum, :step, :precision))
          # If the thresholds have been edited, some values in modules might be out of bound so we clamp them.
          parameter.instances.each do |ins|
            ins.update(value: [parameter.minimum, parameter.maximum, ins.value].sort[1])
          end
          parameter
        end

        def validate! **payload
          build(**payload).validate!
        end

        def delete(parameter)
          parameter.instances.each(&:delete)
          parameter.delete
        end

        def model
          Modusynth::Models::Blueprints::ParameterTemplate
        end
      end
    end
  end
end
