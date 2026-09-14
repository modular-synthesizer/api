# frozen_string_literal: true

module Modusynth
  module Controllers
    module Blueprints
      class Controls < Modusynth::Controllers::Blueprints::Base
        api_route 'post', '/', right: ::Rights::TOOLS_WRITE do
          control = service.create(**symbolized_params, blueprint:)
          render_json 'blueprints/_control.json', status: 201, control:
        end

        api_route 'put', '/:id', right: ::Rights::TOOLS_WRITE do
          control = service.find_and_update(**symbolized_params)
          render_json 'blueprints/_control.json', control:
        end

        def service
          Modusynth::Services::Blueprints::Controls.instance
        end
      end
    end
  end
end
