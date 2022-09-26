module Modusynth
  module Services
    class Ownership
      include Singleton

      # Checks that the resource belongs to the given authentication token
      def check resource, auth_token
        session = auth_session auth_token
        return unless resource.respond_to? :account
        raise forbidden if session.expired?
        raise forbidden if resource.account != session.account
        resource
      end

      def forbidden
        Modusynth::Exceptions.forbidden 'auth_token'
      end

      def auth_session auth_token
        result = Modusynth::Models::Session.where(token: auth_token).first
        raise Modusynth::Exceptions.unknown 'auth_token' if result.nil?
        result
      end
    end
  end
end