# frozen_string_literal: true

module Modusynth
  module Controllers
    module V2
      class Synthesizers < Modusynth::Controllers::Base
        api_route 'get', '/:id', right: ::Rights::SYNTHESIZERS_READ do
          ::Modusynth::Features::Synthesizers::Find.new(session:, **symbolized_params).run
          halt 200, {}.to_json
        end
      end
    end
  end
end
