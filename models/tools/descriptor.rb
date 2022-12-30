module Modusynth
  module Models
    module Tools
      # A descriptor gives constraints concerning a type of parameter. These constraints are then applied to the
      # parameter with the same name on the nodes the Parameter object is targeting.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Descriptor
        include Mongoid::Document

        store_in collection: 'tools_descriptors'

        # @!attribute [rw] field
        #   @return [String] the name of the field the parameters linked to this descriptor will be applied on.
        field :field, type: String
        # @!attribute [rw] name
        #   @return [String] the identifying name of the descriptor, the name is supposedly uniq, but can not be.
        field :name, type: String
        # @!attribute [rw] default
        #   @return [Float] the value that will be given to the parameter when instanciating it, before any edit.
        field :default, type: Float
        # @!attribute [rw] minimum
        #   @return [Integer] the minimal value the parameter can have to be considered valid.
        field :minimum, type: Integer
        # @!attribute [rw] maximum
        #   @return [Integer] the maximal value the parameter can have to be considered valid.
        field :maximum, type: Integer
        # @!attribute [rw] precision
        #   @return [Integer] the number of digits to display after the comma for decimal numbers.
        field :precision, type: Integer
        # @!attribute [rw] step
        #   @return [Float] a value can only be modified by this amount when editing it via a knob.
        field :step, type: Float

        # @!attribute [rw] parameters
        #   @return [Array<Modusynth::Models::Tools::Parameter>] the parameters using this descriptor's constraints.
        has_many :parameters,
          class_name: '::Modusynth::Models::Tools::Parameter',
          inverse_of: :descriptor

        [:name, :minimum, :maximum, :step, :precision, :default].each do |field|
          validates_presence_of field, message: 'required'
        end
        
        validate :boundaries

        validate :default_value

        def boundaries
          return if minimum.nil? || maximum.nil?
          errors.add(:boundaries, 'order') unless minimum <= maximum
        end

        def default_value
          return if default.nil? || minimum.nil? || maximum.nil?
          errors.add(:default, 'value') unless minimum <= default && maximum >= default
        end
      end
    end
  end
end