# frozen_string_literal: true

module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base
      def synthesizer
        result = service.find_or_fail(params['id'])
        ownership.check result, auth_session
        result
      end

      get '/' do
        synthesizers = service.list.map do |synthesizer|
          Modusynth::Decorators::Synthesizer.new(synthesizer).to_simple_h
        end
        halt 200, { synthesizers: synthesizers }.to_json
      end

      get '/:id' do
        halt 200, decorate(synthesizer).to_json
      end

      put '/:id' do
        halt 200, decorate(service.update(synthesizer, body_params)).to_json
      end

      post '/' do
        halt 201, decorate(service.create(body_params, auth_session)).to_json
      end

      delete '/:id' do
        service.delete(synthesizer)
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
