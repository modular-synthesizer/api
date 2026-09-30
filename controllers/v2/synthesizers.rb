# frozen_string_literal: true

module Modusynth
  module Controllers
    module V2
      class Synthesizers < Modusynth::Controllers::Base
        api_route 'get', '/:id', right: ::Rights::SYNTHESIZERS_READ do
          synthesizer = find_synthesizer.new(session:, **symbolized_params).run
          membership = find_membership.new(session:, synthesizer:).run
          render_json :'v2/synthesizers/_synthesizer.json', membership:
        end

        def find_synthesizer
          ::Modusynth::Features::Synthesizers::Find
        end

        def find_membership
          ::Modusynth::Features::Synthesizers::FindMembership
        end
      end
    end
  end
end
