module Modusynth
  module Models
    module Tools
      class Descriptor
        include Mongoid::Document

        field :name, type: String

        field :default, type: Float

        field :minimum, type: Integer

        field :maximum, type: Integer

        field :precision, type: Integer

        field :step, type: Float

        validates :name,
          presence: { message: 'required' },
          length: { minimum: 3, message: 'length', if: :name? }

        validates :minimum, presence: { message: 'required' }

        validates :maximum, presence: { message: 'required' }

        validates :step, presence: { message: 'required' }

        validates :precision, presence: { message: 'required' }

        validates :default, presence: { message: 'required' }
        
        validate :boundaries

        validate :steps

        validate :default_value

        has_many :parameters,
          class_name: '::Modusynth::Models::Tools::Parameter',
          inverse_of: :descriptor

        def boundaries
          return if minimum.nil? || maximum.nil?
          errors.add(:boundaries, 'order') unless minimum <= maximum
        end

        def steps
          return if step.nil? || minimum.nil? || maximum.nil?
          errors.add(:step, 'broad') unless step < (maximum - minimum) / 2
        end

        def default_value
          return if default.nil? || minimum.nil? || maximum.nil?
          errors.add(:default, 'value') unless minimum <= default && maximum >= default
        end
      end
    end
  end
end