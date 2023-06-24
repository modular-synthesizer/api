# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Controls < Modusynth::Controllers::Base
        api_route 'post', '/', admin: true do
          tool = tools_service.find_or_fail(id: symbolized_params[:tool_id], field: 'tool_id')
          control = service.create(**symbolized_params, tool:)
          render_json 'tools/_control.json', status: 201, control:
        end

        api_route 'put', '/:id', admin: true do
          control = service.find_and_update(**symbolized_params)
          render_json 'tools/_control.json', control:
        end

        api_route 'delete', '/:id', admin: true do
          service.remove(**symbolized_params)
          halt 204
        end

        def service
          Modusynth::Services::ToolsResources::Controls.instance
        end

        def tools_service
          Modusynth::Services::Tools::Find.instance
        end
      end
    end
  end
end
