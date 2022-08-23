module Modusynth
  module Models
    module Tools
      class Parameter
        include Mongoid::Document

        field :name, type: String

        field :label, type: String

        field :linked, type: Array

        field :value, type: Integer

        embeds_many :constraints, class_name: 'Models::Tools::Constraints'
      end
    end
  end
end