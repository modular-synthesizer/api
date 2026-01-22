# frozen_string_literal: true

module Modusynth
  module Controllers
    class Categories < Modusynth::Controllers::Base
      endpoint 'post', '/:uuid/categories', right: ::Rights::CATEGORIES_WRITE do
        category = service.create(**symbolized_params)
        render_json 'categories/_category.json', status: 201, category:
      end

      endpoint 'get', '/:uuid/categories', right: ::Rights::CATEGORIES_READ do
        render_json 'categories/list.json', categories: service.list.to_a
      end

      endpoint 'put', '/:uuid/categories/:id', right: ::Rights::CATEGORIES_WRITE do
        category = service.find_and_update(**symbolized_params)
        render_json 'categories/_category.json', category:
      end

      endpoint 'delete', '/:uuid/categories/:id', right: ::Rights::CATEGORIES_WRITE do
        service.remove(id: params[:id])
        halt 204
      end

      def service
        Modusynth::Services::Categories.instance
      end
    end
  end
end
