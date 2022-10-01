# frozen_string_literal: true

module Modusynth
  module Controllers
    class Categories < Modusynth::Controllers::Base
      api_route 'post', '/', admin: true do
        halt 201, service.create(body_params).to_json
      end

      api_route 'get', '/' do
        halt 200, service.list.to_json
      end

      api_route 'put', '/:id', admin: true do
        halt 200, service.update(params[:id], body_params).to_json
      end

      api_route 'delete', '/:id', admin: true do
        service.delete(params[:id])
        halt 204
      end

      def service
        Modusynth::Services::Categories.instance
      end
    end
  end
end
