# frozen_string_literal: true

module Modusynth
  module Controllers
    class Groups < Modusynth::Controllers::Base
      api_route 'get', '/', right: ::Rights::GROUPS_READ do
        render_json 'groups/list.json', groups: service.list
      end

      api_route 'get', '/:id', right: ::Rights::GROUPS_READ do
        group = service.find_or_fail(id: payload[:id])
        render_json 'groups/_group.json', group:
      end

      api_route 'post', '/', right: ::Rights::GROUPS_WRITE do
        group = service.create(**symbolized_params)
        render_json 'groups/_group.json', status: 201, group:
      end

      api_route 'put', '/:id', right: ::Rights::GROUPS_WRITE do
        group = service.find_and_update(**symbolized_params)
        render_json 'groups/_group.json', group:
      end

      api_route 'delete', '/:id', right: ::Rights::GROUPS_WRITE do
        service.remove(id: payload[:id])
        halt 204
      end

      private

      def service
        Modusynth::Services::Permissions::Groups.instance
      end
    end
  end
end
