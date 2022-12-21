module Modusynth
  module Controllers
    class Scopes < Modusynth::Controllers::Base
      api_route 'get', '/', admin: true do
        results = service.list.map { |scope| decorate(scope) }
        halt 200, results.to_json
      end
      api_route 'get', '/:id', admin: true do
        scope = service.find_or_fail(id: params[:id])
        halt 200, decorate(scope).to_json
      end
      api_route 'post', '/', admin: true do
        scope = service.create(label: body_params['label'])
        halt 201, decorate(scope).to_json
      end
      api_route 'delete', '/:id', admin: true do
        service.delete(id: params[:id])
        halt 204
      end

      private

      def service
        Modusynth::Services::Permissions::Scopes.instance
      end
      def decorate scope
        Modusynth::Decorators::Scope.new(scope).to_h
      end
    end
  end
end