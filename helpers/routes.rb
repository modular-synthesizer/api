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
          if ENV['RACK_ENV'] != 'test'
            Modusynth::Services::OAuth::Applications.instance.authenticate(
              request.env['HTTP_X_PUBLIC_KEY'],
              request.env['HTTP_X_PRIVATE_KEY']
            )
          end
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

      def create_right(right: nil, **_)
        Modusynth::Models::Permissions::Right.find_or_create_by(label: right)
      end

      def with_defaults(options)
        { authenticated: true, ownership: nil }.merge options
      end
    end
  end
end
