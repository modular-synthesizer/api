# frozen_string_literal: true

module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base
      api_route 'get', '/' do
        results = service.list(@session.account).map do |synthesizer|
          Modusynth::Decorators::Synthesizer.new(synthesizer).to_simple_h
        end
        halt 200, { synthesizers: results }.to_json
      end

      api_route 'get', '/:id', ownership: true do
        halt 200, decorate(@resource).to_json
      end

      api_route 'put', '/:id', ownership: true do
        halt 200, decorate(service.update(@resource, body_params)).to_json
      end

      api_route 'post', '/' do
        halt 201, decorate(service.create(body_params, @session.account)).to_json
      end

      api_route 'delete', '/:id', ownership: true do
        service.delete(@resource)
        halt 200, { message: 'deleted' }.to_json
      end

      def service
        Modusynth::Services::Synthesizers.instance
      end

      def decorate(item)
        Modusynth::Decorators::Synthesizer.new(item).to_h
      end
    end
  end
end
