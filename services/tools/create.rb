module Modusynth
  module Services
    module Tools
      class Create
        include Singleton
        
        def create **payload
          tool = build(**payload)
          tool.save!
          tool
        end

        def build name: nil, slots: nil, nodes: [], links: [], parameters: [], controls: [], ports: [], categoryId: nil
          Modusynth::Models::Tool.new(
            name:,
            slots:,
            # nodes: build_nodes(nodes),
            links: create_links(links)
            # parameters: build_parameters(parameters),
            # controls: build_controls(controls),
            # ports: build_ports(ports),
            # category: get_category(categoryId)
          )
        end

        private

        def build_nodes raw_nodes
          raw_nodes.map do |raw_node|
            Modusynth::Models::Tools::InnerNode.new(**raw_node)
          end
        end

        def build_links raw_links
          raw_links.map.with_index do |raw_link, index|
            Modusynth::Services::Tools::Links.build(index:, **raw_link)
          end
        end
      end
    end
  end
end