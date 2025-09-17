# frozen_string_literal: true

module Modusynth
  module Controllers
    # TODO : add tests for this controller, currently deemed VERY UNSTABLE but yet critical to the application.
    class Links < Modusynth::Controllers::Base
      api_route 'get', '/', right: ::Rights::SYNTHESIZERS_READ do
        links = service.list(params)
        render_json 'links/list.json', links:
      end

      api_route 'get', '/v2', right: ::Rights::SYNTHESIZERS_READ do
        links = service.list(params)
        render_json 'links/list_v2.json', links:
      end

      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        link = service.create(session: @session, **symbolized_params)
        rendered = jbuilder :'links/_link.json', locals: { link: }
        notifier.command(Commands.add_cable(link), link.synthesizer.sessions, rendered)
        halt 201, rendered
      end

      api_route 'put', '/:id', ownership: true, right: ::Rights::SYNTHESIZERS_WRITE do
        link = service.update(params[:id], body_params)
        render_json 'links/_link.json', link:
      end

      api_route 'delete', '/:id', ownership: true, right: ::Rights::SYNTHESIZERS_WRITE do
        link = service.find(**symbolized_params)
        service.remove(**symbolized_params)
        unless link.nil?
          rendered = jbuilder :'links/_link.json', locals: { link: }
          notifier.command(Commands.remove_cable(link), link.synthesizer.sessions, rendered)
        end
        halt 204
      end

      def service
        Modusynth::Services::Links.instance
      end
    end
  end
end
