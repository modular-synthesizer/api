module Modusynth
  module Controllers
    module ToolsResources
      class InnerNodes < Modusynth::Controllers::ToolsResources::Base
        api_route 'post', '/', admin: true do
          node = service.create(**symbolized_params, tool:)
          render_json 'tools/_node.json', status: 201, node:
        end

        api_route 'put', '/:id', admin: true do
          node = service.find_and_update(**symbolized_params, container: tool.inner_nodes)
          render_json 'tools/_node.json', node:
        end
        
        def service
          Modusynth::Services::ToolsResources::InnerNodes.instance
        end

        def container
          tool.inner_nodes
        end
      end
    end
  end
end