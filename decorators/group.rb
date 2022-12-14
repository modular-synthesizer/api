# frozen_string_literal: true

module Modusynth
  module Decorators
    class Group < Draper::Decorator
      def to_h
        {
          slug: object.slug,
          scopes: scopes
        }
      end

      def scopes
        object.scopes.sort_by(&:label).map(&:label)
      end
    end
  end
end
