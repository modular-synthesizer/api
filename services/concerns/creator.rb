module Modusynth
  module Services
    module Concerns
      # This module provides methods to build and persist items. It needs the definition of a #build method in the
      # class implementing this module as concern. This method will have all the arguments passed to #create passed
      # down to it. To use it, the developer MUST implement the #build method in the service suing it, and MAY
      # implement the #validate! method to add validation rules for payloads.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module Creator
        extend ActiveSupport::Concern

        # Builds and persists the item with the given parameters after validating the payload.
        def create **payload
          tool = build_and_validate!(**payload)
          tool.save!
          tool
        end

        # Syntactic sugar to create an entire list of items easily.
        def build_all items
          items.map do |item|
            build_and_validate!(**item)
          end
        end

        # Validates the payload with the rules defined in the service, and builds the item without persisting it.
        def build_and_validate! **payload
          validate!(**payload) if respond_to?(:validate!, true)
          build(**payload)
        end
      end
    end
  end
end