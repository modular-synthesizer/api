# frozen_string_literal: true

module Modusynth
  module Controllers
    # TODO : add tests for this controller, currently deemed VERY UNSTABLE but yet critical to the application.
    class Links < Modusynth::Controllers::Base
      api_route 'get', '/' do
        links = service.list(params)
        render_json 'links/list.json', links:
      end

      api_route 'post', '/' do
        link = service.create(session: @session, **symbolized_params)
        render_json 'links/_link.json', status: 201, link:
      end

      api_route 'put', '/:id', ownership: true do
        link = service.update(params[:id], body_params)
        render_json 'links/_link.json', link:
      end

      api_route 'delete', '/:id' do
        service.remove(id: params[:id])
        halt 204
      end

      def service
        Modusynth::Services::Links.instance
      end
    end
  end
end
