# frozen_string_literal: true

module Modusynth
  module Controllers
    class Memberships < Modusynth::Controllers::Base
      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        membership = service.create(session:, **symbolized_params)
        synthesizer = render_synthesizer(membership)
        notifier.command(Commands::ADD_MEMBERSHIP, membership.account.sessions, synthesizer)
        render_json 'synthesizers/_membership.json', status: 201, membership:
      end

      api_route 'delete', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        membership = service.find(id: symbolized_params[:id])
        unless membership.nil?
          synthesizer = render_synthesizer(membership)
          notifier.command(Commands::REMOVE_MEMBERSHIP, membership.account.sessions, synthesizer)
        end
        service.remove(session:, **symbolized_params)
        halt 204
      end

      def service
        Modusynth::Services::Memberships.instance
      end

      def render_synthesizer(membership)
        jbuilder :'synthesizers/_synthesizer.json', locals: { membership: }
      end
    end
  end
end
