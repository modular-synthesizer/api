# frozen_string_literal: true

module Modusynth
  module Models
    module Concerns
      module Control
        extend ActiveSupport::Concern

        included do
          # @!attribute [rw] component
          #   @return [String] the name of the component, on the client-side, used to render this control.
          field :component, type: String
          # @!attribute [rw] payload
          #   @return [Hash] the attributes passed to the component as props. If an attribute is not defined,
          #     the default value for this key will be used on the client side.
          field :payload, type: Hash, default: {}

          validate :component_presence

          validate :component_format

          def component_presence
            errors.add(:component, 'required') if component.nil?
          end

          def component_format
            errors.add(:component, 'format') if !component.nil? && /\A[A-Z][A-Za-z]*\Z/ !~ component
          end
        end
      end
    end
  end
end
