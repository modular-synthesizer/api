# frozen_string_literal: true

module Modusynth
  module Models
    module Tools
      class Component
        include Mongoid::Document

        # @!attribute [rw] filename
        #   @return [string] the name of the component the frontend will have to dynamically mount.
        field :component_name, type: String

        # @!attributes [rw] variables
        #   @return [Array<ComponentAttributes>] the variables that can be accessed in the corresponding controls.
        embeds_many :variables, class_name: '::Modusynth::Models::Tools::ComponentAttribute', inverse_of: :component

        has_many :controls, class_name: '::Modusynth::Models::Control', inverse_of: :component

        validates :component_name,
                  presence: { message: 'required' },
                  format: { with: /\A[A-Z][A-Za-z]*\Z/, message: 'format', if: :component_name }
      end

      # An attribute is a pair of a name and a type defining a possible variable in a control.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class ComponentAttribute
        include Mongoid::Document
        include Modusynth::Models::Concerns::Enumerable

        field :name, type: String

        enum_field :type, %i[string number], default: :number

        embedded_in :component, class_name: ':/Modusynth::Models::Tools::Component', inverse_of: :variables

        validates :name, presence: { message: 'required' }

        validates :type, presence: { message: 'required' }
      end
    end
  end
end
