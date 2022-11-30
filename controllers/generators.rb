# frozen_string_literal: true

module Modusynth
  module Controllers
    class Generators < Modusynth::Controllers::Base
      api_route 'post', '/', admin: true do
        halt 201, service.create(body_params).to_json
      end

      api_route 'get', '/' do
        halt 200, service.list.to_json
      end

      def service
        Modusynth::Services::Generators.instance
      end
    end
  end
end
