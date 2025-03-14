# frozen_string_literal: true

module Modusynth
  module Controllers
    class Parameters < Modusynth::Controllers::Base
      api_route 'put', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        parameter = service.update(session:, **symbolized_params)
        rendered = jbuilder :'modules/_parameter.json', locals: { parameter: }
        sessions = parameter.module.synthesizer.sessions
        notifier.command(Commands.update_param(parameter), sessions, rendered)
        halt 200, rendered
      end

      def service
        ::Modusynth::Services::Parameters.instance
      end
    end
  end
end
