# frozen_string_literal: true

module Modusynth
  module Controllers
    class Rights < Modusynth::Controllers::Base
      api_route 'get', '/', right: ::Rights::RIGHTS_READ do
        rights = service.list
        render_json 'rights/list.json', rights:
      end
      api_route 'get', '/:id', right: ::Rights::RIGHTS_READ do
        right = service.find_or_fail(id: params[:id])
        render_json 'rights/_right.json', right:
      end
      api_route 'post', '/', right: ::Rights::RIGHTS_WRITE do
        right = service.create(**symbolized_params)
        render_json 'rights/_right.json', status: 201, right:
      end
      api_route 'delete', '/:id', right: ::Rights::RIGHTS_WRITE do
        service.remove(id: params[:id])
        halt 204
      end

      private

      def service
        Modusynth::Services::Permissions::Rights.instance
      end
    end
  end
end
