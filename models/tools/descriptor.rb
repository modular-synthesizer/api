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

        field :name, type: String

        field :default, type: Float

        field :minimum, type: Integer

        field :maximum, type: Integer

        field :precision, type: Integer

        field :step, type: Float

        has_many :parameters,
          class_name: '::Modusynth::Models::Tools::Parameter',
          inverse_of: :descriptor

        validates :name, presence: { message: 'required' }

        validates :minimum, presence: { message: 'required' }

        validates :maximum, presence: { message: 'required' }

        validates :step, presence: { message: 'required' }

        validates :precision, presence: { message: 'required' }

        validates :default, presence: { message: 'required' }
        
        validate :boundaries

        validate :default_value

        def boundaries
          return if minimum.nil? || maximum.nil?
          errors.add(:boundaries, 'order') unless minimum <= maximum
        end

        def steps
          return if step.nil? || minimum.nil? || maximum.nil?
          errors.add(:step, 'broad') unless step * 2 < (maximum - minimum)
        end

        def default_value
          return if default.nil? || minimum.nil? || maximum.nil?
          errors.add(:default, 'value') unless minimum <= default && maximum >= default
        end
      end
    end
  end
end