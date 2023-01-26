# frozen_string_literal: true

module Modusynth
  module Controllers
    class Categories < Modusynth::Controllers::Base
      api_route 'post', '/', admin: true do
        category = service.create(**symbolized_params)
        render_json 'categories/_category.json', status: 201, category:
      end

      api_route 'get', '/' do
        render_json 'categories/list.json', categories: service.list.to_a
      end

      api_route 'put', '/:id', admin: true do
        category = service.find_and_update(**symbolized_params)
        render_json 'categories/_category.json', category:
      end

      api_route 'delete', '/:id', admin: true do
        service.remove(id: params[:id])
        halt 204
      end

      def service
        Modusynth::Services::Categories.instance
      end
    end
  end
end
