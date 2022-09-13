module Modusynth
  module Models
    module Tools
      class Parameter
        include Mongoid::Document

        field :name, type: String

        field :targets, type: Array, default: []

        field :default, type: Integer

        field :minimum, type: Integer

        field :maximum, type: Integer

        field :precision, type: Integer

        field :step, type: Integer

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

        validate :targets_types

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

        def targets_types
          return if targets.nil? || !targets.kind_of?(Array)
          targets.each.with_index do |target, index|
            return errors.add(:"targets[#{index}]", 'type') unless target.kind_of?(String)
          end
        end
      end
    end
  end
end