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
          parameters: [],
          controls: [],
          ports: [],
          categoryId: nil,
          **rest
        )
          Modusynth::Models::Tool.new(
            name:,
            slots:,
            inner_nodes: InnerNodes.instance.build_all(nodes, prefix: 'nodes'),
            inner_links: Links.instance.build_all(links, prefix: 'links'),
            parameters: Parameters.instance.build_all(parameters, prefix: 'parameters'),
            controls: Controls.instance.build_all(controls, prefix: 'controls'),
            ports: Ports.instance.build_all(ports, prefix: 'ports'),
            category: Categories.instance.find_or_fail(id: categoryId, field: 'categoryId')
          )
        end

        def validate! **payload
          if payload[:categoryId].nil?
            raise Modusynth::Exceptions::Service.new(key: 'categoryId', error: 'required')
          end
          build(**payload).validate!
        end
      end
    end
  end
end
