# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      ACCOUNT_VIEW = 'accounts/account.json'

      api_route 'post', '/', authenticated: false do
        account = service.create(**symbolized_params)
        render_json ACCOUNT_VIEW, status: 201, account:
      end

      api_route 'get', '/search', right: ::Rights::ACCOUNTS_READ do
        accounts = service.search(session:, **symbolized_params)
        render_json 'accounts/list.json', accounts:
      end

      api_route 'get', '/own', right: ::Rights::ACCOUNTS_READ do
        account = service.find_or_fail(id: @session.account.id)
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'get', '/:id', right: ::Rights::ACCOUNTS_ADMIN do
        account = service.find_or_fail(id: params[:id])
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'put', '/:id/groups', right: ::Rights::ACCOUNTS_ADMIN do
        account = service.find_and_update_groups(**symbolized_params)
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'put', '/own', right: ::Rights::ACCOUNTS_WRITE do
        account = service.find_and_update(
          **symbolized_params, id: @session.account.id.to_s,
                               session: @session
        )
        render_json ACCOUNT_VIEW, account:
      end

      api_route 'put', '/:id', right: ::Rights::ACCOUNTS_ADMIN do
        account = service.find_and_update(**symbolized_params, session: @session)
        render_json ACCOUNT_VIEW, account:
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
