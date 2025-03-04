# frozen_string_literal: true

module Modusynth
  module Controllers
    class Modules < Modusynth::Controllers::Base
      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        mod = service.create(**symbolized_params)
        rendered = jbuilder :'modules/_module.json', locals: { mod: }
        notifier.command(Commands.add_module(mod), mod.synthesizer.sessions, rendered)
        halt 201, rendered
      end

      api_route 'get', '/', right: ::Rights::SYNTHESIZERS_READ do
        mods = service.list(**symbolized_params)
        render_json 'modules/list.json', mods:
      end

      api_route 'put', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        mod = service.update(session:, **symbolized_params)
        render_json 'modules/_module.json', mod:
      end

      api_route 'delete', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        mod = service.remove(session:, **symbolized_params)
        if mod
          rendered = jbuilder :'modules/_module.json', locals: { mod: }
          notifier.command(Commands.remove_module(mod), mod.synthesizer.sessions, rendered)
        end
        halt 204
      end

      def service
        Modusynth::Services::Modules.instance
      end
    end
  end
end
