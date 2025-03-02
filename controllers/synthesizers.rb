# frozen_string_literal: true

module Modusynth
  module Controllers
    class Synthesizers < Modusynth::Controllers::Base
      api_route 'get', '/', right: ::Rights::SYNTHESIZERS_READ do
        memberships = service.list(@session.account, **symbolized_params)
        render_json 'synthesizers/list.json', memberships:
      end

      api_route 'get', '/:id', right: ::Rights::SYNTHESIZERS_READ do
        synthesizer = service.find_or_fail(**symbolized_params)
        membership = synthesizer.guest(account: @session.account)
        render_json 'synthesizers/_synthesizer.json', membership:
      end

      api_route 'put', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        synthesizer = service.find_and_update(**symbolized_params)
        membership = synthesizer.creator
        render_json 'synthesizers/_synthesizer.json', membership:
      end

      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        synthesizer = service.create(account: @session.account, **symbolized_params)
        membership = synthesizer.guest(account: @session.account)
        render_json 'synthesizers/_synthesizer.json', status: 201, membership:
      end

      api_route 'delete', '/:id', right: ::Rights::SYNTHESIZERS_WRITE do
        synthesizer = service.find(**symbolized_params)
        synthesizer&.memberships&.each do |m|
          puts "Sending delete to #{m.account.username}"
          notifier.command(Commands::REMOVE_MEMBERSHIP, m.account.sessions, render_synthesizer(m))
        end
        service.remove(session:, **symbolized_params)
        halt 204
      end

      def service
        Modusynth::Services::Synthesizers.instance
      end

      def render_synthesizer(membership)
        jbuilder :'synthesizers/_synthesizer.json', locals: { membership: }
      end
    end
  end
end
