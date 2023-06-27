module Modusynth
  module Models
    module Tools
      # This represents a pluggable port in the module. This is NOT representing the control displayed on the screen,
      # but the port itself, and the possibility to plug a link in, with where the link will be internally plugged.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Port
        include Mongoid::Document

        store_in collection: 'tools_ports'

        # @!attribute [rw] kind
        #   @return [String] the kind of port (INPUT or OUTPUT) to know what it can be connected to.
        field :kind, type: String
        # @!attribute [rw] name
        #   @return [String] a name identifying the port to be targeted in controls.
        field :name, type: String
        # @!attribute [rw] target
        #   @return [String] the name of the inner nodes this port is targeting.
        field :target, type: String
        # @!attribute [rw] index
        #   @return [Integer] the index on which to connect this port on the inner node (above or equal zero).
        field :index, type: Integer, default: 0

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }
        
        validates :index,
          presence: { message: 'required' },
          numericality: { greater_than: -1, message: 'value', if: :index? }

        validates :kind,
          presence: { message: 'required' },
          inclusion: { in: %w(input output), message: 'value' }

        scope :inputs, ->{ where(kind: 'input') }

        scope :outputs, ->{ where(kind: 'output') }

        # @!attribute [rw] tool
        #   @return [Modusynth::Models::Tool] the tool in which the port is declared.
        belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :ports, optional: true
      end
    end
  end
end