# frozen_string_literal: true

module Modusynth
  module Controllers
    # Controller for the tools allowing the user to
    # create new modules in an existing synthesizer.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Tools < Base
      # The route to build the list of tools. It returns a subset
      # of fields from the tools to make it as light as possible.
      api_route 'get', '/' do
        criteria = @session.account.admin ? {} : { experimental: false }
        tools = service.list(**criteria).to_a
        render_json 'tools/list.json', tools:
      end

      api_route 'get', '/:id' do
        render_json 'tools/details.json', tool: service.find_or_fail(id: params[:id])
      end

      api_route 'post', '/', admin: true do
        tool = Modusynth::Services::Tools::Create.instance.create(**symbolized_params)
        render_json 'tools/details.json', status: 201, tool:
      end

      api_route 'put', '/:id', admin: true do
        tool = Modusynth::Services::Tools::Update.instance.find_and_update(**symbolized_params)
        render_json 'tools/details.json', tool:
      end

      api_route 'delete', '/:id', admin: true do
        Modusynth::Services::Tools::Delete.instance.remove(id: params[:id])
        halt 204
      end

      def service
        Modusynth::Services::Tools::Find.instance
      end
    end
  end
end
