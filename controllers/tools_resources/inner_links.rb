module Modusynth
  module Controllers
    module ToolsResources
      class InnerLinks < Modusynth::Controllers::ToolsResources::Base

        api_route 'post', '/', admin: true do
          link = service.create(**symbolized_params, tool:)
          render_json 'tools/_link.json', status: 201, link:
        end

        def service
          Modusynth::Services::ToolsResources::InnerLinks.instance
        end
        
        def container
          tool.inner_links
        end
      end
    end
  end
end