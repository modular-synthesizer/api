module Modusynth
  module Services
    class Ownership
      include Singleton

      # Checks that the resource belongs to the given authentication token
      # resource [Object] any resource responding to :belongs_to to check that it belongs to
      #   the corresponding session.
      # 
      def check resource, session
        return unless resource.respond_to? :belongs_to?
        resource.belongs_to? session
      end
    end
  end
end