module Modusynth
  module Controllers
    class Links < Modusynth::Controllers::Base
      get '/' do
        results = service.list(params).map do |item|
          decorate(item)
        end
        halt 200, results.to_json
      end

      post '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      put '/:id' do
        halt 200, decorate(service.update(params[:id], body_params)).to_json
      end

      delete '/:id' do
        service.delete(params[:id])
        halt 200, {message: 'deleted'}.to_json
      end

      def service
        Modusynth::Services::Links.instance
      end

      def decorate item
        Modusynth::Decorators::Link.new(item).to_h
      end
    end
  end
end