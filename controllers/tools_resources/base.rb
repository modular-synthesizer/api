module Modusynth
  module Controllers
    module ToolsResources
      class Base < Modusynth::Controllers::Base

        attr_reader :tool

        def tools_service
          Modusynth::Services::Tools::Find.instance
        end

        before do
          next unless request.post?
          @tool = tools_service.find_or_fail(id: symbolized_params[:tool_id], field: 'tool_id')
        end

        api_route 'delete', '/:id', admin: true do
          service.remove(**symbolized_params)
          halt 204
        end
      end
    end
  end
end