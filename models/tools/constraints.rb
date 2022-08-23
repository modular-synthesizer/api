module Modusynth
  module Models
    module Tools
      # Constraints are binding the values of parameters to certains values,
      # precision or govern the increase/decrease of values in the frontend.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Constraints
        include Mongoid::Document

        # @!attribute [rw] name
        #   @return [String] The name of the constraint, indicating how it will
        #     be used on the frontend side. For example a constraint called
        #     "min" will indicating a minimum value the user can't go below.
        field :name, type: string

        # @!attribute [rw] value
        #   @return [Integer] the value associated to the constraint, for example
        #     for a minimum value it will be the number the value of the parameter
        #     is not allowed to go below.
        field :value, type: Integer
      end
    end
  end
end