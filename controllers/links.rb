# frozen_string_literal: true

module Modusynth
  module Controllers
    class Links < Modusynth::Controllers::Base
      api_route 'get', '/' do
        results = service.list(params).map do |item|
          decorate(item)
        end
        halt 200, results.to_json
      end

      api_route 'post', '/' do
        halt 201, decorate(service.create(body_params)).to_json
      end

      api_route 'put', '/:id', ownership: true do
        halt 200, decorate(service.update(params[:id], body_params)).to_json
      end

      api_route 'delete', '/:id', ownership: true do
        service.delete(params[:id])
        halt 200, { message: 'deleted' }.to_json
      end

      def service
        Modusynth::Services::Links.instance
      end

      def decorate(item)
        Modusynth::Decorators::Link.new(item).to_h
      end
    end
  end
end
