# frozen_string_literal: true

module Modusynth
  module Controllers
    class Modules < Modusynth::Controllers::Base
      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        mod = service.create(**symbolized_params)
        render_json 'modules/_module.json', status: 201, mod:, session:
      end

      api_route 'get', '/', right: ::Rights::SYNTHESIZERS_READ do
        mods = service.list(**symbolized_params)
        render_json 'modules/list.json', mods:, session:
      end

      api_route 'put', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        mod = service.update(session:, **symbolized_params)
        render_json 'modules/_module.json', mod:, session:
      end

      api_route 'delete', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        service.remove(session:, **symbolized_params)
        halt 204
      end

      api_route 'put', '/:module_id/parameters/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        parameter = parameters_service.update(session:, **symbolized_params)
        parameters_service.notify_update(notifier, parameter, render_parameter(s, parameter))
        render_json 'modules/_parameter.json', parameter:, session:
      end

      def service
        Modusynth::Services::Modules.instance
      end

      def parameters_service
        Modusynth::Services::Parameters.instance
      end

      def render_parameter(parameter)
        jbuilder :'modules/_parameter.json', locals: { parameter: }
      end
    end
  end
end
