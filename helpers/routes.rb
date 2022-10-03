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

        send verb, path do
          if options[:authenticated]
            @session = auth_service.authenticate(body_params) 
            auth_service.check_privileges(@session) if options[:admin]
            if options[:ownership] == true && respond_to?(:service)
              @resource = auth_service.ownership(body_params, @session, service)
            end
          end
          instance_eval(&block)
        end
      end

      # Add the default values for all fields in the options hash.
      # @param [Hash] the options that were passed to the route
      #   declaration function call. Any key that is in this hash
      #   will override the corresponding key in the default hash.
      # @return [Hash] the hash with the default values added for
      #   the corresponding keys.
      def with_defaults(options)
        defaults = {
          authenticated: true,
          ownership: nil,
          # Indicates if the route is ONLY accessible to admins.
          admin: false
        }
        defaults.merge options
      end
    end
  end
end