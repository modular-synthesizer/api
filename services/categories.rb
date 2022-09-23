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

      def update id, payload
        category = find_or_fail(id)
        category.update(**payload.slice('name'))
        decorator.new(category).to_h
      end

      def list
        model.all.map do |category|
          decorator.new(category).to_h
        end
      end

      def delete id
        find_or_fail(id).delete
      end

      def find_or_fail id
        item = model.find(id)
        raise Modusynth::Exceptions.unknown if item.nil?
        item
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