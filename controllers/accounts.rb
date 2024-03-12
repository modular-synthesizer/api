# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      ACCOUNT_VIEW = 'accounts/account.json'

      api_route 'post', '/', authenticated: false do
        account = service.create(**symbolized_params)
        render_json ACCOUNT_VIEW, status: 201, account:
      end

      api_route 'get', '/search' do
        accounts = service.search(session:, **symbolized_params)
        render_json 'accounts/list.json', accounts:
      end

      api_route 'get', '/own' do
        account = service.find_or_fail(id: @session.account.id)
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'get', '/:id', admin: true do
        account = service.find_or_fail(id: params[:id])
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'put', '/:id/groups', admin: true do
        account = service.find_and_update_groups(**symbolized_params)
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'put', '/:id' do
        account = service.find_and_update(**symbolized_params, session: @session)
        render_json ACCOUNT_VIEW, account:
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
