module Modusynth
  module Decorators
    class Scope < Draper::Decorator
      delegate_all

      def to_h
        {
          id: object.id.to_s,
          label: object.label,
          groups: groups
        }
      end

      def groups
        object.groups.sort_by(&:slug).map do |group|
          {id: group.id.to_s, slug: group.slug}
        end
      end
    end
  end
end