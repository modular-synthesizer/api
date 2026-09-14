# frozen_string_literal: true

module Modusynth
  module Services
    module Blueprints
      class Controls < Modusynth::Services::Base
        include Singleton

        def find_in_blueprint(blueprint: nil, id: nil, **_)
          raise Modusynth::Exceptions.required('blueprint_id') if id.nil?

          parameter = blueprint.controls.find_by(id:)
          raise Modusynth::Exceptions.unknown('id') if parameter.nil?

          parameter
        end

        def build blueprint: nil, component: nil, payload: {}, **_
          model.new(blueprint:, component:, payload:)
        end

        def remove_in_blueprint(blueprint: nil, id: nil, **_)
          blueprint.controls.find_by(id:)&.delete
        end

        def update control, **payload
          control.update(payload.slice(:component, :payload))
          control.validate!
          control
        end

        def model
          Modusynth::Models::Blueprints::ControlTemplate
        end
      end
    end
  end
end
