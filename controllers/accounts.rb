# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      ACCOUNT_VIEW = 'accounts/account.json'

      post '/accounts' do
        account = service.create(**symbolized_params)
        render_json ACCOUNT_VIEW, status: 201, account:
      end

      endpoint 'get', '/:uuid/accounts', right: ::Rights::ACCOUNTS_READ do
        render_json 'accounts/list.json', accounts: service.search(**symbolized_params)
      end

      endpoint 'get', '/:uuid/profile', right: ::Rights::ACCOUNTS_READ do
        render_json ACCOUNT_VIEW, account:
      end

      endpoint 'put', '/:uuid/groups', right: ::Rights::ACCOUNTS_ADMIN do
        account = service.find_and_update_groups(**symbolized_params)
        render_json ACCOUNT_VIEW, account:
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
