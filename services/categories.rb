module Modusynth
  module Services
    # This service handles CRUD operations about categories. write Operations here
    # MUST be accessible only to authorizzed users when the permission system is
    # fully implemented as not everyone should be able to create/destroy them.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Categories
      include Singleton

      def create payload
        category = model.new(payload.slice('name'))
        category.save!
        decorator.new(category).to_h
      end

      def model
        Modusynth::Models::Category
      end

      def decorator
        Modusynth::Decorators::Category
      end
    end
  end
end