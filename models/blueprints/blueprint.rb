# frozen_string_literal: true

module Modusynth
  module Models
    module Blueprints
      # Represents a blueprint able to create new nodes when instanciated.
      # Nodes have an interior world comprised of Web Audio API nodes
      # and links between them. They expose parameters and ports linked
      # to inner elements so that the user can interact with them.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Blueprint
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in collection: 'blueprints'

        # @!attribute [rw] name
        #   @return [String] the name, not necessarily uniq, of the blueprint to get the translation from.
        field :name, type: String
        # @!attribute [rw] slots
        #   @return [Integer] The number of slots the blueprint will take in each rack.
        field :slots, type: Integer
        # @!attribute [rw] experimental
        #   @return [Boolean] TRUE if it is still an experiment and not ready to be released, FALSE otherwise.
        field :experimental, type: Boolean, default: true

        field :x, type: Integer, default: 0

        field :y, type: Integer, default: 0

        field :scale, type: Float, default: 1.0

        belongs_to :category, class_name: '::Modusynth::Models::Category', inverse_of: :blueprints, optional: true

        embeds_many :inner_nodes, class_name: '::Modusynth::Models::Blueprints::InnerNode'

        embeds_many :inner_links, class_name: '::Modusynth::Models::Blueprints::InnerLink'

        # @!attribute [rw] controls
        #   @return [Array<Modusynth::Models::Blueprints::Control>] the list of graphic representation ok controls
        has_many :controls, class_name: '::Modusynth::Models::Blueprints::Control', inverse_of: :blueprint
        # @!attribute [rw] ports
        #   @return [Array<Modusynth::Models::Blueprints::PortTemplate>] the list of exposed I/O ports for the module.
        has_many :ports, class_name: '::Modusynth::Models::Blueprints::PortTemplate', inverse_of: :blueprint

        has_many :parameters, class_name: '::Modusynth::Models::Blueprints::ParameterTemplate', inverse_of: :blueprint

        has_many :modules, class_name: '::Modusynth::Models::Module', inverse_of: :blueprint

        validates :name,
                  presence: { message: 'required' },
                  length: { minimum: 3, message: 'minlength', if: :name? }

        validates :slots,
                  presence: { message: 'required' },
                  numericality: { greater_than: 0, message: 'value', if: :slots? }

        def param(name)
          descriptors = Modusynth::Models::Blueprints::Descriptor.where(name:)
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
end
