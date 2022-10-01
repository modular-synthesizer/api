# frozen_string_literal: true

module Modusynth
  module Controllers
    class Sessions < Modusynth::Controllers::Base
      post '/' do
        halt 201, service.create(body_params).to_json
      end

      api_route 'delete', '/:id', ownership: true do
        service.delete @resource
        halt 200, { token: @resource.token, expired: true }.to_json
      end

      def service
        Modusynth::Services::Sessions.instance
      end
    end
  end
end
