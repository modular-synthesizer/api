# frozen_string_literal: true

module Modusynth
  module Controllers
    class Accounts < Modusynth::Controllers::Base
      post '/' do
        halt 201, service.create(body_params).to_json
      end

      def service
        Modusynth::Services::Accounts.instance
      end
    end
  end
end
