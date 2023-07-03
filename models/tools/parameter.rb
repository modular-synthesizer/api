module Modusynth
  module Models
    module Tools
      # A parameter represents a value of an AudioParam in the client-side application. It links a descriptor setting
      # constraints for the value of the parameter, and a set of targets being inner nodes of the tool the parameter is
      # declared into. After being instanciated, each tool parameter will generate a module parameter.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Parameter
        include Mongoid::Document

        store_in collection: 'tools_parameters'

        # @!attribute [rw] targets
        #   @return [Array<String>] The names of the inner nodes this parameter is applied onto.
        field :targets, type: Array, default: []
        # @!attribute [rw] name
        #   @return [String] The name of the parameter to be able to link controls to it. Supposed uniq.
        field :name, type: String
        # @!attribute [rw] field
        #   @return [String] the name of the field the parameters linked to this descriptor will be applied on.
        field :field, type: String
        # @!attribute [rw] default
        #   @return [Float] the value that will be given to the parameter when instanciating it, before any edit.
        field :default, type: Float, default: 50
        # @!attribute [rw] minimum
        #   @return [Integer] the minimal value the parameter can have to be considered valid.
        field :minimum, type: Integer, default: 0
        # @!attribute [rw] maximum
        #   @return [Integer] the maximal value the parameter can have to be considered valid.
        field :maximum, type: Integer, default: 100
        # @!attribute [rw] precision
        #   @return [Integer] the number of digits to display after the comma for decimal numbers.
        field :precision, type: Integer, default: 0
        # @!attribute [rw] step
        #   @return [Float] a value can only be modified by this amount when editing it via a knob.
        field :step, type: Float, default: 1

        validates :name, presence: { message: 'required' }

        validates :field, presence: { message: 'required' }

        belongs_to :tool, class_name: '::Modusynth::Models::Tool', inverse_of: :parameters, optional: true

        has_many :instances, class_name: '::Modusynth::Models::Modules::Parameter', inverse_of: :parameter

        scope :called, ->(name) {
          descriptors = Modusynth::Models::Tools::Descriptor.where(name: name)
          return where(:descriptor_id.in => descriptors.map(&:id))
        }
        
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