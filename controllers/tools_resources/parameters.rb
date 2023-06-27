# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      class Parameters < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', admin: true do
          parameter = service.create(**symbolized_params, tool:)
          render_json 'tools/_parameter.json', status: 201, parameter:
        end

        api_route 'put', '/:id', admin: true do
          parameter = service.find_and_update(**symbolized_params)
          render_json 'tools/_parameter.json', parameter:
        end

        def service
          Modusynth::Services::ToolsResources::Parameters.instance
        end
      end
    end
  end
end
