# frozen_string_literal: true

module Modusynth
  module Controllers
    class Applications < Modusynth::Controllers::Base
      api_route 'post', '/', admin: true do
        application = service.create(**symbolized_params, session: @session)
        render_json 'applications/_application.json', status: 201, application:
      end

      api_route 'get', '/', admin: true do
        render_json 'applications/list.json', applications: service.list.to_a
      end

      def service
        Modusynth::Services::OAuth::Applications.instance
      end
    end
  end
end
