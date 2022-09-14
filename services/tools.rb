module Modusynth
  module Services
    class Tools
      include Singleton

      def find(id)
        Modusynth::Models::Tool.find(id)
      end

      def find_or_fail id, field = 'id'
        tool = find id
        raise Modusynth::Exceptions.unknown(field) if tool.nil?
        tool
      end

      def create(payload)
        tool = Modusynth::Models::Tool.new(
          name: payload['name'],
          slots: payload['slots'],
          inner_nodes: inner_nodes(payload),
          inner_links: inner_links(payload),
          inputs: ports(payload, 'inputs'),
          outputs: ports(payload, 'outputs')
        )
        tool.parameters = parameters(payload, tool)
        tool.save!
        tool
      end

      def list
        Modusynth::Models::Tool.all.to_a
      end

      private

      def inner_nodes payload
        return [] if payload['inner_nodes'].nil?

        payload['inner_nodes'].map do |node|
          Modusynth::Models::Tools::InnerNode.new(
            name: node['name'],
            generator: node['generator']
          )
        end
      end

      def inner_links payload
        return [] if payload['inner_links'].nil?

        payload['inner_links'].map.with_index do |link, idx|
          validate_link link, idx
          validate_link_nodes link, idx, payload['inner_nodes']
          Modusynth::Models::Tools::InnerLink.new(
            from: inner_link_end(link['from']),
            to: inner_link_end(link['to'])
          )
        end
      end

      def parameters payload, tool
        return [] if payload['parameters'].nil?

        results = payload['parameters'].map.with_index do |param, idx|
          if param['descriptor'].nil?
            raise Modusynth::Exceptions.required("parameters[#{idx}].descriptor")
          end
          descriptor = Modusynth::Models::Tools::Descriptor.find_by(id: param['descriptor'])
          raise Modusynth::Exceptions.unknown("parameters[#{idx}]") if descriptor.nil?
          parameter = Modusynth::Models::Tools::Parameter.new(
            descriptor: descriptor,
            targets: param['targets'] || [],
            tool: tool
          )
          parameter.save!
          parameter
        end

        results
      end

      def inner_link_end raw_end
        Modusynth::Models::Tools::InnerLinkEnd.new(
          node: raw_end['node'],
          index: raw_end['index']
        )
      end

      def validate_link link, index
        ['from', 'to'].each do |link_end|
          unless link.key? link_end
            raise Modusynth::Exceptions.required("inner_links[#{index}].#{link_end}")
          end
          ['node', 'index'].each do |field|
            unless link[link_end].key? field
              raise Modusynth::Exceptions.required("inner_links[#{index}].#{link_end}.#{field}")
            end
          end
        end
      end

      def validate_link_nodes link, index, inner_nodes
        names = inner_nodes.map { |inode| inode['name'] }
        ['from', 'to'].each do |link_end|
          unless names.include? link[link_end]['node']
            raise Modusynth::Exceptions.unknown("inner_links[#{index}].#{link_end}.node")
          end
        end
      end

      def ports payload, key
        return [] if payload[key].nil?

        ports = payload[key].map.with_index do |port, idx|
          unless port['targets'].nil?
            port['targets'].each.with_index do |target, j|
              unless target.kind_of?(String)
                raise Modusynth::Exceptions::BadRequest.new("#{key}[#{idx}].targets[#{j}]", 'type')
              end
            end
          end
          Modusynth::Models::Tools::Port.new(
            name: port['name'],
            targets: port['targets'],
            index: port['index']
          )
        end

        validate_port_nodes payload, key, payload['inner_nodes']
        
        ports
      end

      def validate_port_nodes payload, key, inner_nodes
        names = (inner_nodes || []).map { |inode| inode['name'] }

        (payload[key] || []).each.with_index do |port, i|
          return if port['targets'].nil?
          port['targets'].each.with_index do |target, j|
            unless names.include? target
              raise Modusynth::Exceptions.unknown("#{key}[#{i}].targets[#{j}]")
            end
          end
        end
      end
    end 
  end
end