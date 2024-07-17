# frozen_string_literal: true

module Modusynth
  module Controllers
    class Sessions < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        session = service.create(**symbolized_params)
        render_json 'sessions/_session.json', status: 201, session:
      end

      api_route 'get', '/:id', ownership: true do
        render_json 'sessions/_session.json', session: @resource
      end

      api_route 'delete', '/:id', ownership: true do
        service.remove_if_owner(id: params[:id], account: @session.account)
        halt 204
      end

      def service
        Modusynth::Services::Sessions.instance
      end
    end
  end
end
