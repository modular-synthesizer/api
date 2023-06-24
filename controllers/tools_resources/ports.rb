# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Ports < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', admin: true do
          port = service.create(**symbolized_params, tool:)
          render_json 'tools/_port.json', status: 201, port:
        end

        api_route 'put', '/:id', admin: true do
          port = service.find_and_update(**symbolized_params)
          render_json 'tools/_port.json', port:
        end

        def service
          Modusynth::Services::ToolsResources::Ports.instance
        end
      end
    end
  end
end
