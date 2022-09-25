module Modusynth
  module Services
    class Ownership
      include Singleton

      # Checks that the resource belongs to the given authentication token
      def check resource, auth_session
        return unless resource.respond_to? :account
        raise forbidden if auth_session.expired?
        raise forbidden if resource.account != auth_session.account
      end

      def forbidden
        Modusynth::Exceptions.forbidden 'auth_token'
      end
    end
  end
end