# frozen_string_literal: true

module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base
      api_route 'get', '/' do
        memberships = service.list(@session.account)
        render_json 'synthesizers/list.json', memberships:
      end

      api_route 'get', '/:id' do
        synthesizer = service.find_or_fail(**symbolized_params)
        membership = synthesizer.guest(account: @session.account)
        render_json 'synthesizers/_synthesizer.json', membership:
      end

      api_route 'put', '/:id' do
        synthesizer = service.find_and_update(**symbolized_params)
        membership = synthesizer.creator
        render_json 'synthesizers/_synthesizer.json', membership:
      end

      api_route 'post', '/' do
        synthesizer = service.create(account: @session.account, **symbolized_params)
        membership = synthesizer.guest(account: @session.account)
        render_json 'synthesizers/_synthesizer.json', status: 201, membership:
      end

      api_route 'delete', '/:id' do
        service.remove(session:, **symbolized_params)
        halt 204
      end

      def service
        Modusynth::Services::Synthesizers.instance
      end
    end
  end
end
