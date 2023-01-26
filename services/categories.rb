module Modusynth
  module Services
    # This service handles CRUD operations about categories. write Operations here
    # MUST be accessible only to authorizzed users when the permission system is
    # fully implemented as not everyone should be able to create/destroy them.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Categories < Modusynth::Services::Base
      include Singleton

      def build name: nil, **rest
        model.new(name:)
      end

      def update category, **payload
        category.update(payload.slice(:name))
      end

      def model
        Modusynth::Models::Category
      end
    end
  end
end