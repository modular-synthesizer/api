# frozen_string_literal: true

module Modusynth
  module Controllers
    class Memberships < Modusynth::Controllers::Base
      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        membership = service.create(session:, **symbolized_params)
        rendered = jbuilder :'synthesizers/_membership.json', locals: { membership: }
        notify.command('add.membership', membership.account.sessions, rendered)
        halt 201, rendered
      end

      api_route 'delete', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        service.remove(session:, **symbolized_params)
        halt 204
      end

      def service
        Modusynth::Services::Memberships.instance
      end
    end
  end
end
