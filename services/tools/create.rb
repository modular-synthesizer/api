module Modusynth
  module Services
    module Tools
      class Create
        include Modusynth::Services::Concerns::Creator
        include Singleton

        def build name: nil, slots: nil, nodes: [], links: [], parameters: [], controls: [], ports: [], categoryId: nil
          Modusynth::Models::Tool.new(
            name:,
            slots:,
            inner_nodes: InnerNodes.instance.build_all(nodes, prefix: 'nodes'),
            inner_links: Links.instance.build_all(links, prefix: 'links'),
            # parameters: build_parameters(parameters),
            # controls: build_controls(controls),
            ports: Ports.instance.build_all(ports, prefix: 'ports'),
            # category: get_category(categoryId)
          )
        end
      end
    end
  end
end