module Modusynth
  module Models
    # Represents a tool able to create new nodes when instanciated.
    # Nodes have an interior world comprised of Web Audio API nodes
    # and links between them. They expose parameters and ports linked
    # to inner elements so that the user can interact with them.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Tool
      include Mongoid::Document
      include Mongoid::Timestamps

      field :name, type: String

      # @!attribute [rw] slots
      # @return [Integer] The number of slots the tool will take in each rack.
      field :slots, type: Integer, default: 2

      validates :slots,
        numericality: { greater_than: 0, message: 'value' }
      
      validates :name,
        presence: { message: 'required' },
        length: { minimum: 1, message: 'length', if: :name? }

      embeds_many :inner_nodes, class_name: 'Models::Tools::InnerNode', inverse_of: :tool
    end
  end
end