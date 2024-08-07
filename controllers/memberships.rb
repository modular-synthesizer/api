# frozen_string_literal: true

module Modusynth
  module Controllers
    class Memberships < Modusynth::Controllers::Base
      api_route 'post', '/', right: ::Rights::SYNTHESIZERS_WRITE do
        membership = service.create(session:, **symbolized_params)
        render_json 'synthesizers/_membership.json', status: 201, membership:
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
