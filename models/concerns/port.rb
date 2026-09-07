# frozen_string_literal: true

module Modusynth
  module Models
    module Concerns
      module Port
        extend ActiveSupport::Concern

        included do # rubocop:disable Metrics/BlockLength
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

          %i[name_presence name_length index_presence index_value kind_presence kind_value].each do |rule|
            validate rule
          end

          def name_presence
            errors.add(:name, 'required') if name.nil? || name.empty?
          end

          def name_length
            errors.add(:name, 'length') if !name.nil? && name.length < 3
          end

          def index_presence
            errors.add(:index, 'required') if index.nil?
          end

          def index_value
            errors.add(:index, 'value') if !index.nil? && index.negative?
          end

          def kind_presence
            errors.add(:kind, 'required') if kind.nil?
          end

          def kind_value
            errors.add(:kind, 'value') if !kind.nil? && !%w[input output].include?(kind)
          end

          scope :inputs, -> { where(kind: 'input') }
          scope :outputs, -> { where(kind: 'output') }
        end
      end
    end
  end
end
