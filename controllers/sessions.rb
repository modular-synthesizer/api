# frozen_string_literal: true

module Modusynth
  module Controllers
    class Sessions < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        session = service.create(**symbolized_params)
        rights = Modusynth::Services::Permissions::Rights.instance.for_session(session)
        render_json 'sessions/_session.json', status: 201, session:, rights:
      end

      api_route 'get', '/:id', ownership: true do
        rights = Modusynth::Services::Permissions::Rights.instance.for_session(@session).map(&:label).uniq
        render_json 'sessions/_session.json', session: @resource, rights:
      end

      api_route 'delete', '/:id' do
        service.remove_if_owner(id: params[:id], account: @session.account)
        halt 204
      end

      def service
        Modusynth::Services::Sessions.instance
      end
    end
  end
end
