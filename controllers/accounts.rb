# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        halt 201, service.create(body_params).to_json
      end

      api_route 'get', '/:id', ownership: true do
        halt 200, Modusynth::Decorators::Account.new(@resource).to_json
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
