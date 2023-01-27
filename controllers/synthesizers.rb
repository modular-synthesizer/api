# frozen_string_literal: true

module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base
      api_route 'get', '/' do
        synthesizers = service.list(@session.account)
        render_json 'synthesizers/list.json', synthesizers:
      end

      api_route 'get', '/:id', ownership: true do
        render_json 'synthesizers/_synthesizer.json', synthesizer: @resource
      end

      api_route 'put', '/:id', ownership: true do
        synthesizer = service.update(@resource, body_params)
        render_json 'synthesizers/_synthesizer.json', synthesizer:
      end

      api_route 'post', '/' do
        synthesizer = service.create(account: @session.account, **symbolized_params)
        render_json 'synthesizers/_synthesizer.json', status: 201, synthesizer:
      end

      api_route 'delete', '/:id' do
        service.remove_if_owner(id: params[:id], account: @session.account)
        halt 204
      end

      def service
        Modusynth::Services::Synthesizers.instance
      end
    end
  end
end
