# frozen_string_literal: true

module Modusynth
  module Controllers
    class Groups < Modusynth::Controllers::Base
      api_route 'get', '/' do
        render_json 'groups/list.json', groups: service.list
      end

      get '/:id' do
        group = service.find_or_fail(id: payload[:id])
        render_json 'groups/_group.json', group:
      end

      api_route 'post', '/', admin: true do
        group = service.create(slug: payload[:slug])
        render_json 'groups/_group.json', status: 201, group:
      end

      api_route 'put', '/:id', admin: true do
        group = service.find_and_update(**symbolized_params)
        render_json 'groups/_group.json', group:
      end

      delete '/:id' do
        service.delete(id: payload[:id])
        halt 204
      end

      private

      def service
        Modusynth::Services::Permissions::Groups.instance
      end
    end
  end
end
