# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Controls < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', admin: true do
          control = service.create(**symbolized_params, tool:)
          render_json 'tools/_control.json', status: 201, control:
        end

        api_route 'put', '/:id', admin: true do
          control = service.find_and_update(**symbolized_params)
          render_json 'tools/_control.json', control:
        end

        def service
          Modusynth::Services::ToolsResources::Controls.instance
        end
      end
    end
  end
end
