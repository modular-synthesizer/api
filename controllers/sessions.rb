# frozen_string_literal: true

module Modusynth
  module Controllers
    class Sessions < Modusynth::Controllers::Base
      post '/' do
        halt 201, service.create(body_params).to_json
      end

      delete '/:token' do
        deleted = service.delete(params[:token], auth_session)
        halt 200, { token: deleted.token, expired: true }.to_json
      end

      def service
        Modusynth::Services::Sessions.instance
      end
    end
  end
end
