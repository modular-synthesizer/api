module Modusynth
  module Services
    class Tools
      include Singleton

      def create(payload)
        tool = Modusynth::Models::Tool.new(
          name: payload['name'],
          slots: payload['slots'],
          inner_nodes: inner_nodes(payload),
          inner_links: inner_links(payload),
          parameters: parameters(payload)
        )
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
            factory: node['factory']
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

      def parameters payload
        return [] if payload['parameters'].nil?

        payload['parameters'].map.with_index do |param|
          Modusynth::Models::Tools::Parameter.find(param)
        end
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
    end
  end
end