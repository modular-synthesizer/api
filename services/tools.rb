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
            type: node['type'],
            payload: node['payload']
          )
        end
      end
    end
  end
end