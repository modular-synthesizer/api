# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Parameters < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', right: ::Rights::TOOLS_WRITE do
          parameter = service.create_embedded(container: blueprint, collection: :parameters, **symbolized_params)
          render_json 'blueprints/_parameter.json', status: 201, parameter:
        end

        api_route 'put', '/:id', right: ::Rights::TOOLS_WRITE do
          parameter = service.find_in_blueprint(**symbolized_params, blueprint:)
          parameter = service.update(parameter, **symbolized_params)
          render_json 'blueprints/_parameter.json', parameter:
        end

        api_route 'delete', '/:id', right: ::Rights::TOOLS_WRITE do
          service.remove_in_blueprint(**symbolized_params, blueprint:)
          halt 204
        end

        def service
          Modusynth::Services::ToolsResources::Parameters.instance
        end
      end
    end
  end
end
