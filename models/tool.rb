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
      include Mongoid::EmbeddedErrors

      store_in collection: 'tools'

      field :name, type: String

      # @!attribute [rw] slots
      # @return [Integer] The number of slots the tool will take in each rack.
      field :slots, type: Integer

      belongs_to :category, class_name: '::Modusynth::Models::Category', inverse_of: :tools, optional: true

      embeds_many :inner_nodes, class_name: '::Modusynth::Models::Tools::InnerNode'

      embeds_many :inner_links, class_name: '::Modusynth::Models::Tools::InnerLink'

      has_many :ports, class_name: '::Modusynth::Models::Tools::Port', inverse_of: :tool

      has_many :parameters, class_name: '::Modusynth::Models::Tools::Parameter', inverse_of: :tool

      has_many :modules, class_name: '::Modusynth::Models::Module', inverse_of: :tool
      
      validates :name,
        presence: { message: 'required' },
        length: { minimum: 3, message: 'length', if: :name? }

      validates :slots,
        presence: { message: 'required' },
        numericality: { greater_than: 0, message: 'value', if: :slots? }

      def param name
        descriptors = Modusynth::Models::Tools::Descriptor.where(name: name)
        parameters.where(:descriptor_id.in => descriptors.map(&:id).map(&:to_s)).first
      end

      def inputs
        ports.where(kind: 'input').to_a
      end

      def outputs
        ports.where(kind: 'output').to_a
      end
    end
  end
end