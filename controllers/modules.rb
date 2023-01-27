# frozen_string_literal: true

module Modusynth
  module Controllers
    class Modules < Modusynth::Controllers::Base
      api_route 'post', '/' do
        mod = service.create(**symbolized_params)
        render_json 'modules/_module.json', status: 201, mod:
      end

      api_route 'get', '/' do
        mods = service.list(params)
        render_json 'modules/list.json', mods:
      end

      api_route 'put', '/:id', ownership: true do
        mod = service.update(params[:id], body_params)
        render_json 'modules/_module.json', mod:
      end

      api_route 'delete', '/:id' do
        service.remove_if_owner(id: params[:id], account: @session.account)
        halt 204
      end

      def service
        Modusynth::Services::Modules.instance
      end
    end
  end
end
