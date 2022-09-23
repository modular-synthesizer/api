module Modusynth
  module Controllers
    class Categories < Modusynth::Controllers::Base

      post '/' do
        halt 201, service.create(body_params).to_json
      end

      get '/' do
        halt 200, service.list.to_json
      end

      put '/:id' do
        halt 200, service.update(params[:id], body_params).to_json
      end

      delete '/:id' do
        service.delete(params[:id])
        halt 204
      end

      def service
        Modusynth::Services::Categories.instance
      end
    end
  end
end