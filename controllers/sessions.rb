# frozen_string_literal: true

module Modusynth
  module Controllers
    class Sessions < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        account = service.create(**symbolized_params)
        halt 201, decorate(account).to_json
      end

      api_route 'get', '/:id', ownership: true do
        halt 200, decorate(@resource).to_json
      end

      api_route 'delete', '/:id' do
        service.remove_if_owner(id: params[:id], account: @session.account)
        halt 204
      end

      def service
        Modusynth::Services::Sessions.instance
      end

      def decorate item
        return Modusynth::Decorators::Session.new(item).to_h
      end
    end
  end
end
