module Modusynth
  module Services
    class Authentication
      include Singleton

      # Authenticates a user given a payload passed as parameter of a
      # request in a controller. Conditions for authentication are :
      # - The payload MUST contain a :auth_token key
      # - The authentication token MUST exist in a session in the database
      # - The session MUST be linked to an account in the database
      # - The session MUST NOT be marked as expired
      #
      # @param payload [Hash] the parameters sent to the request, either
      #   in the JSON body or in the querystring.
      #
      # @raise [Modusynth::Exceptions::BadRequest] if the aut_token field
      #   if not provided in the payload.
      # @raise [Modusynth::Exceptions::Unknown] if the session is not found.
      # @raise [Modusynth::Exceptions::Forbidden] if the session is expired
      #   or not linked to any account, thus have no right to access the route.
      #
      # @return [Modusynth::Models::Session] the authentication session for the
      #   user currently making the request.
      def authenticate payload
        unless payload.key? :auth_token
          raise Modusynth::Exceptions.required :auth_token
        end
        # The :find_or_fail method will raise not found errors if needed.
        session = sessions.find_or_fail(id: payload[:auth_token], field: 'auth_token')
        if session.account.nil? || session.expired?
          raise Modusynth::Exceptions.forbidden
        end
        session
      end

      # Raises an error if the user is not an administrator. It is used to
      # forbid normal users to access routes such as tools or parameters
      # management so that they don't modify the application's data.
      #
      # @param session [Modusynth::Models::Session] the session makind the request.
      # @raise [Modusynth::Exceptions::Forbidden] if the user is not admin.
      def check_privileges session
        raise Modusynth::Exceptions.forbidden unless session.account.admin
      end

      def check_rights session, right
        account_rights = Modusynth::Services::Permissions::Rights.instance.for_session(session).map(&:label)
        raise Modusynth::Exceptions.forbidden unless account_rights.include? right
      end

      # Checks if the user making the request has access to the resource. To
      # find the resource, the UUID is extracted from the payoad.
      #
      # @param payload [Hash] the parameters sent in the request, either in the
      #   JSON body, or directly in the querystring.
      # @param options [Hash] the options declared when creating the route in
      #   the application, with in particular the key :service that indicates
      #   which service to use to get the resource.
      #
      # @raise [Modusynth::Exceptions::Unknown] if the resource has not been
      #   found using the corresponding model.
      # @raise [Modusynth::Exceptions::Forbidden] if the user is not allowed
      #   to interact with this model instance.
      #
      # @return [Object] the instance of the resource found if not exception
      #   has been raised.
      def ownership payload, session, service
        return unless service.respond_to?(:find_or_fail)
        
        resource = service.find_or_fail(id: payload[:id])

        # Ownership cannot be checked if the model does not respond to :account.
        return unless resource.respond_to? :account

        return resource if session.account.admin

        if resource.account != session.account 
          raise Modusynth::Exceptions.forbidden
        end
        resource
      end

      def sessions
        Modusynth::Services::Sessions.instance
      end
    end
  end
end