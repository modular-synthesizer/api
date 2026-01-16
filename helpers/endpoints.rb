# frozen_string_literal: true

module Modusynth
  module Helpers
    module Endpoints
      DEFAULT_OPTIONS = { authenticated: true, right: [], admin: false }.freeze

      # Declares an API endpoint wrapping a route. An API endpoint has options concerning the check of
      # authentication or permissions for the user making the request. It creates the right if needed.
      #
      # @param verb [String] any HTTP verb, case-insensitive.
      # @param path [String] absolute URI to match after the prefix of the controller.
      # @param options [Hash] a hash of options that can be passed to alter the endpoint behaviour.
      def endpoint verb, path, **options, &block
        options = DEFAULT_OPTIONS.merge(options)
        create_right(**options) if options.key? :right
        send verb.downcase, path do
          check_authenticated_constraints(**options) if options[:authenticated]
          instance_eval(&block)
        rescue StandardError
          raise_forbidden_account
        end
      end

      def self.registered(app)
        app.helpers Modusynth::Helpers::Endpoints::Methods
      end

      def create_right(right: nil, **_)
        Modusynth::Models::Permissions::Right.find_or_create_by(label: right)
      end

      module Methods
        def accounts_service
          Modusynth::Services::Accounts.instance
        end

        def auth_service
          Modusynth::Services::Authentication.instance
        end

        def raise_forbidden_account
          raise Modusynth::Exceptions.forbidden 'account_id'
        end

        def account
          @account ||= accounts_service.find_by(uuid: symbolized_params[:uuid])
        end

        def token
          @token ||= Modusynth::Services::Tokens.instance.parse(account:, **symbolized_params)
        end

        def token_expired?
          token[0]['exp'] < Time.now.to_i
        end

        def jwt_token_id
          @jwt_token_id ||= token[0]['jti']
        end

        def stored_token
          @stored_token ||= Modusynth::Services::Tokens.instance.find_by(jwt_token_id:)
        end

        private

        # Checks the constraints a logged in user MUST respect to access its resources
        # Conditions are :
        # - The user MUST have a valid JWT token registered on our side.
        # - The user MUST have one of the right if rights are required to access the endpoint.
        #
        # @param right [Array<String>] an array of rights labels. A user MUST possess at least one to success.
        def check_authenticated_constraints(right: [], **_)
          raise_forbidden_account if token_expired? || !stored_token
          auth_service.check_rights(account, right) unless right.empty?
        end
      end
    end
  end
end
