module Modusynth
  module Controllers
    module ToolsResources
      class Base < Modusynth::Controllers::Base

        def tools_service
          Modusynth::Services::Tools::Find.instance
        end

        api_route 'delete', '/:id', admin: true do
          service.remove(**symbolized_params, container:)
          halt 204
        end

        def tool
          tools_service.find_or_fail(id: symbolized_params[:tool_id], field: 'tool_id')
        end

        def container
          nil
        end
      end
    end
  end
end