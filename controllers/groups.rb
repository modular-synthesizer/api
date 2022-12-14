module Modusynth
  module Controllers
    class Groups < Modusynth::Controllers::Base
      api_route 'get', '/' do
        results = service.list.map do |group|
          decorator.new(group).to_h
        end
        halt 200, results.to_json
      end

      get '/:id' do
        halt 200, find_or_fail(id: params[:id]).to_h.to_json
      end

      api_route 'post', '/', admin: true do
        group = service.create(slug: body_params['slug'])
        halt 201, decorator.new(group).to_h.to_json
      end

      put '/:id' do
        group = service.update(**body_params)
      end

      delete '/:id' do
        service.delete(id: params[:id])
        halt 204
      end

      private

      def service
        Modusynth::Services::Permissions::Groups.instance
      end

      def decorator
        Modusynth::Decorators::Group
      end
    end
  end
end