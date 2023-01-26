# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        account = service.create(**symbolized_params)
        render_json 'accounts/account.json', status: 201, account:
      end

      api_route 'get', '/:id' do
        account = service.find_or_fail(id: params[:id])
        render_json 'accounts/account.json', account:
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
