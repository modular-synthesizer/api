# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Ports < Modusynth::Controllers::Base
        api_route 'post', '/', admin: true do
          tool = tools_service.find_or_fail(id: symbolized_params[:tool_id], field: 'tool_id')
          port = service.create(**symbolized_params, tool:)
          render_json 'tools/_port.json', status: 201, port:
        end

        api_route 'put', '/:id', admin: true do
          port = service.find_and_update(**symbolized_params)
          render_json 'tools/_port.json', port:
        end

        api_route 'delete', '/:id', admin: true do
          service.remove(id: symbolized_params[:id])
          halt 204
        end

        def service
          Modusynth::Services::ToolsResources::Ports.instance
        end

        def tools_service
          Modusynth::Services::Tools::Find.instance
        end
      end
    end
  end
end