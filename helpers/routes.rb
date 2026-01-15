# rubocop:disable Metrics/AbcSize
# frozen_string_literal: true

module Modusynth
  module Helpers
    # This module holds logic for declaring new routes on the API.
    # The api_route delcarator add new features to the traditional
    # Sinatra get/post/... functions, with authentication, checking
    # the ownership of a resource, or the permissions of the user.
    module Routes
      def api_route(verb, path, **options, &block)
        options = with_defaults options
        auth_service = Modusynth::Services::Authentication.instance

        create_right(**options) if options.key? :right

        send verb, path do
          if options[:authenticated]
            @session = auth_service.authenticate(symbolized_params)
            auth_service.check_privileges(@session) if options[:admin]
            auth_service.check_rights(@session, options[:right]) if options.key? :right
            if options[:ownership] == true && respond_to?(:service)
              @resource = auth_service.ownership(symbolized_params, @session, service)
            end
          end
          instance_eval(&block)
        end
      end

      def new_route(verb, path, authenticated: true, right: [], ownership: false, admin: false, &block)
        send verb, path do
          auth_service = Modusynth::Services::Authentication.instance
          if authenticated
            @account = Modusynth::Services::Accounts.instance.find_or_fail(id: symbolized_params[:account_id])
            @token = Modusynth::Services::Tokens.instance.parse(account: @account, **symbolized_params)
            raise Modusynth::Exceptions.forbidden 'account_id' if @token[0]['exp'] < Time.now.to_i

            auth_service.check_privileges(@account) if admin
            auth_service.check_rights(@account, right) unless right.empty?
            @stored_token = Modusynth::Models::Token.active.find_by(jwt_token_id: @token[0]['jti'])
            raise Modusynth::Exceptions.forbidden 'account_id' if @stored_token.nil?
          end
          @resource = auth_service.ownership(symbolized_params, account, service) if ownership && respond_to?(:service)
          instance_eval(&block)
        rescue StandardError
          raise Modusynth::Exceptions.forbidden 'account_id'
        end
      end

      def token
        @token ||= JWT.decode(symbolized_params[:jwt_token], account.username, 'HS256')
      end

      def account
        @account ||= account.find_or_fail_username(token[0][:sub])
      end

      def create_right(right: nil, **_)
        Modusynth::Models::Permissions::Right.find_or_create_by(label: right)
      end

      def auth_service
        Modusynth::Services::Authentication.instance
      end

      def tokens_service
        Modusynth::Services::Tokens.instance
      end

      def with_defaults(options)
        { authenticated: true, ownership: nil }.merge options
      end
    end
  end
end

# rubocop:enable Metrics/AbcSize
