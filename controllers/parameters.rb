# frozen_string_literal: true

module Modusynth
  module Controllers
    class Parameters < Modusynth::Controllers::Base
      api_route 'get', '/' do
        results = service.list.map { |param| decorate(param).to_h }
        halt 200, { parameters: results }.to_json
      end

      api_route 'post', '/', admin: true do
        halt 201, decorate(service.create(body_params)).to_json
      end

      def service
        Modusynth::Services::Parameters.instance
      end

      def decorate(item)
        Modusynth::Decorators::Descriptor.new(item).to_h
      end
    end
  end
end
