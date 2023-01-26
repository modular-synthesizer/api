# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        halt 201, service.create(body_params).to_json
      end

      api_route 'get', '/:id' do
        account = service.find_or_fail(id: params[:id])

        halt 200, Modusynth::Decorators::Account.new(account).to_h.to_json
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
