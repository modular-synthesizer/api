module Modusynth
  module Controllers
    class Tokens < Modusynth::Controllers::Base
      api_route 'post', '/', authenticated: false do
        token = service.create(**symbolized_params)
        render_json 'tokens/_token.json', status: 201, token:
      end

      private

      def service
        Modusynth::Services::Tokens.instance
      end
    end
  end
end
