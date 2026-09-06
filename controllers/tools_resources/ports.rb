# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Ports < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', right: ::Rights::TOOLS_WRITE do
          port = service.create(**symbolized_params, blueprint:)
          render_json 'blueprints/_port.json', status: 201, port:
        end

        api_route 'put', '/:id', right: ::Rights::TOOLS_WRITE do
          port = service.find_in_blueprint(**symbolized_params, blueprint:)
          port = service.update(port, **symbolized_params)
          render_json 'blueprints/_port.json', port:
        end

        api_route 'delete', '/:id', right: ::Rights::TOOLS_WRITE do
          service.remove_in_blueprint(**symbolized_params, blueprint:)
          halt 204
        end

        def service
          Modusynth::Services::ToolsResources::Ports.instance
        end
      end
    end
  end
end
