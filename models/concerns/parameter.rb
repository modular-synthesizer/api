module Modusynth
  module Models
    module Concerns
      module Parameters
        include do
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

          belongs_to :blueprint, class_name: '::Modusynth::Models::Blueprints::Blueprint', inverse_of: :parameters,
                                optional: true

          has_many :instances, class_name: '::Modusynth::Models::Modules::Parameter', inverse_of: :template

          validate :boundaries

          validate :default_value

          def boundaries
            errors.add(:boundaries, 'order') if minimum && maximum && minimum > maximum
          end

          def default_value
            return if default.nil? || minimum.nil? || maximum.nil?

            errors.add(:default, 'value') if minimum > default || maximum < default
          end
        end
      end
    end
  end
end