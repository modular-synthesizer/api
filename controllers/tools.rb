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
        render_json 'tools/list.json', tools: service.list(**criteria).to_a
      end

      api_route 'get', '/:id' do
        render_json 'tools/_tool.json', tool: service.find_or_fail(id: params[:id])
      end

      api_route 'post', '/', admin: true do
        tool = Modusynth::Services::Tools::Create.instance.create(**symbolized_params)
        render_json 'tools/_tool.json', status: 201, tool:
      end

      api_route 'put', '/:id', admin: true do
        tool = Modusynth::Services::Tools::Update.instance.find_and_update(**symbolized_params)
        render_json 'tools/_tool.json', tool:
      end

      api_route 'delete', '/:id', admin: true do
        Modusynth::Services::Tools::Delete.instance.remove(id: params[:id])
        halt 204
      end

      # The following routes are used when editing a tool to add or remove items from resources.

      [:ports].each do |resource|
        api_route 'post', "/:tool_id/#{resource}", admin: true do
          port = services[resource].create(**symbolized_params)
          render_json "tools/#{services[resource].view}.json", status: 201, port:
        end

        api_route 'delete', '/:tool_id/:resource/:id', admin: true do
          services[resource].remove_in(**symbolized_params)
          halt 204
        end
      end

      def service
        Modusynth::Services::Tools::Find.instance
      end

      def services
        {
          ports: Modusynth::Services::Tools::Ports.instance
        }
      end
    end
  end
end
