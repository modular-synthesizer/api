module Modusynth
  module Controllers
    class Modules < Modusynth::Controllers::Base
      post '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      get '/' do
        results = service.list(params).map do |node|
          decorate(node).to_h
        end
        halt 200, results.to_json
      end

      put '/:id' do
        halt 200, decorate(service.update(params[:id], body_params)).to_json
      end

      delete '/:id' do
        service.delete(params[:id])
        halt 200, {message: 'deleted'}.to_json
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