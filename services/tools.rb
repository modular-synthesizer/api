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
          category_id: payload['category_id']
        )
        all_ports(payload).each.with_index do |port, idx|
          begin
            tool.ports << port
            port.validate!
          rescue ActiveModel::ValidationError => exception
            raise Modusynth::Exceptions.from_active_model exception, "ports[#{idx}]"
          end
        end
        tool.parameters = parameters(payload, tool)
        tool.save!
        tool.ports.each(&:save!)
        tool
      end

      # Lists all the tools group by their category name. Category names will be
      # the keys of a hash where values are an array of tools linked to this
      # category as simple hashes.
      #
      # @return [Hash<String,Array<Hash>>] the results as a hash where values
      #   are lists of tools linked to the corresponding key being the category
      #   name.
      def list
        results = Modusynth::Models::Tool.all.to_a.reduce({}) do |list, item|
          cname = item.category.name rescue 'tools'
          decorated = Modusynth::Decorators::Tool.new(item).to_simple_h
          list[cname] = [*list[cname].to_a, decorated]
          list
        end
      end

      private

      def category(payload)
        Modusynth::Models::Category.where(id: payload['category_id'])
      end

      def all_ports payload
        ports(payload, 'inputs') + ports(payload, 'outputs')
      end

      def inner_nodes payload
        (payload['innerNodes'] || []).map do |node|
          Modusynth::Models::Tools::InnerNode.new(
            name: node['name'],
            generator: node['generator']
          )
        end
      end

      def inner_links payload
        (payload['innerLinks'] || []).map.with_index do |link, idx|
          validate_link link, idx
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
            tool: tool,
            x: param['x'],
            y: param['y']
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
            raise Modusynth::Exceptions.required("innerLinks[#{index}].#{link_end}")
          end
          ['node', 'index'].each do |field|
            unless link[link_end].key? field
              raise Modusynth::Exceptions.required("innerLinks[#{index}].#{link_end}.#{field}")
            end
          end
        end
      end

      def validate_link_nodes link, index, inner_nodes
        names = inner_nodes.map { |inode| inode['name'] }
        ['from', 'to'].each do |link_end|
          unless names.include? link[link_end]['node']
            raise Modusynth::Exceptions.unknown("innerLinks[#{index}].#{link_end}.node")
          end
        end
      end

      def ports payload, key
        (payload[key] || []).map.with_index do |port, idx|
          Modusynth::Models::Tools::Port.new(
            name: port['name'],
            target: port['target'],
            index: port['index'],
            kind: key[0..-2] # Removes the trailing S from "outputs" or "inputs"
          )
        end
      end
    end 
  end
end