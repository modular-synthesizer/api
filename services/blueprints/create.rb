module Modusynth
  module Services
    module Blueprints
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
          blueprint = Modusynth::Models::Blueprints::Blueprint.new(
            name:,
            slots:,
            experimental:,
            category: Categories.instance.find_or_fail(id: categoryId, field: 'categoryId')
          )
          blueprint.ports = ports_service.build_with_tool(blueprint, ports, prefix: 'ports')
          blueprint.parameters = params_service.build_with_tool(blueprint, parameters, prefix: 'parameters')
          blueprint.controls = controls_service.build_with_tool(blueprint, controls, prefix: 'controls')
          blueprint.inner_nodes = nodes_service.build_with_tool(blueprint, nodes, prefix: 'nodes')
          blueprint.inner_links = links_service.build_with_tool(blueprint, links, prefix: 'links')
          blueprint
        end

        def validate! **payload
          raise Modusynth::Exceptions::Service.new(key: 'categoryId', error: 'required') if payload[:categoryId].nil?

          build(**payload).validate!
        end

        private

        def ports_service
          Modusynth::Services::ToolsResources::Ports.instance
        end

        def params_service
          Modusynth::Services::ToolsResources::Parameters.instance
        end

        def controls_service
          Modusynth::Services::ToolsResources::Controls.instance
        end

        def nodes_service
          Modusynth::Services::ToolsResources::InnerNodes.instance
        end

        def links_service
          Modusynth::Services::ToolsResources::InnerLinks.instance
        end
      end
    end
  end
end
