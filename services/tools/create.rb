module Modusynth
  module Services
    module Tools
      class Create
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build(
          name: nil,
          slots: nil,
          nodes: [],
          links: [],
          ports: [],
          parameters: [],
          controls: [],
          categoryId: nil,
          experimental: true,
          **rest
        )
          tool = Modusynth::Models::Tool.new(
            name:,
            slots:,
            experimental:,
            inner_nodes: InnerNodes.instance.build_all(nodes, prefix: 'nodes'),
            inner_links: Links.instance.build_all(links, prefix: 'links'),
            controls: Controls.instance.build_all(controls, prefix: 'controls'),
            category: Categories.instance.find_or_fail(id: categoryId, field: 'categoryId')
          )
          tool.ports = ports_service.build_with_tool(tool, ports, prefix: 'ports')
          tool.parameters = params_service.build_with_tool(tool, parameters, prefix: 'parameters')
          tool
        end

        def validate! **payload
          if payload[:categoryId].nil?
            raise Modusynth::Exceptions::Service.new(key: 'categoryId', error: 'required')
          end
          build(**payload).validate!
        end

        private

        def ports_service
          Modusynth::Services::ToolsResources::Ports.instance
        end

        def params_service
          Modusynth::Services::ToolsResources::Parameters.instance
        end
      end
    end
  end
end
