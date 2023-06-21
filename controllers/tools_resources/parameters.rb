# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Parameters < Modusynth::Controllers::Base
        api_route 'post', '/', admin: true do
          tool = tools_service.find_or_fail(id: symbolized_params[:tool_id], field: 'tool_id')
          parameter = service.create(**symbolized_params, tool:)
          render_json 'tools/_parameter.json', status: 201, parameter:
        end

        api_route 'put', '/:id', admin: true do
          parameter = service.find_and_update(**symbolized_params)
          render_json 'tools/_parameter.json', parameter:
        end

        api_route 'delete', '/:id', admin: true do
          service.remove(id: symbolized_params[:id])
          halt 204
        end

        def service
          Modusynth::Services::ToolsResources::Parameters.instance
        end

        def tools_service
          Modusynth::Services::Tools::Find.instance
        end
      end
    end
  end
end
