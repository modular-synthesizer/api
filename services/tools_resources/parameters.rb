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

        def find_in_blueprint(blueprint: nil, id: nil, **_)
          raise Modusynth::Exceptions.required('id') if id.nil?

          parameter = blueprint.parameters.find_by(id:)
          raise Modusynth::Exceptions.unknown('id') if parameter.nil?

          parameter
        end

        def remove_in_blueprint(blueprint: nil, id: nil, **_)
          blueprint.parameters.find_by(id:)&.delete
        end

        def update parameter, **payload
          parameter.update(payload.slice(:name, :targets, :field, :minimum, :default, :maximum, :step, :precision))
          parameter.validate!
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
