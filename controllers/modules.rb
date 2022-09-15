module Modusynth
  module Controllers
    class Modules < Modusynth::Controllers::Base
      post '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      put '/:id' do
        halt 200, decorate(service.update(params[:id], body_params)).to_json
      end

      delete '/:id' do
        service.delete(params[:id])
        halt 204, {message: 'ok'}.to_json
      end

      def decorate item
        Modusynth::Decorators::Module.new(item).to_h
      end

      def service
        Modusynth::Services::Modules.instance
      end
    end
  end
end