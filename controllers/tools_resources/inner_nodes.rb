module Modusynth
  module Controllers
    module ToolsResources
      class InnerNodes < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', admin: true do
          node = service.create(**symbolized_params, tool:)
          render_json 'tools/_node.json', status: 201, node:
        end

        def service
          Modusynth::Services::ToolsResources::InnerNodes.instance
        end
      end
    end
  end
end