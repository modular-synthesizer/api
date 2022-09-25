module Modusynth
  module Controllers
    class Sessions < Modusynth::Controllers::Base
      post '/' do
        halt 201, service.create(body_params).to_json
      end

      def service
        Modusynth::Services::Sessions.instance
      end
    end
  end
end