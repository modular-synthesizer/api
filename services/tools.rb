module Modusynth
  module Services
    class Tools
      include Singleton

      def create(payload)
        tool = Modusynth::Models::Tool.new(
          name: payload['name'],
          slots: payload['slots'],
          inner_nodes: inner_nodes(payload)
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

        payload['inner_links'].map do |link|
          Modusynth::Models::Tools::InnerLink.new(
            from: inner_link_end('from'),
            to: inner_link_end('to')
          )
        end
      end

      def inner_link_end link, extrem
        Modusynth::Models::Tools::InnerLinkEnd.new(
          node: link[extrem]['node'],
          index: link[extrem]['index']
        )
      end
    end
  end
end