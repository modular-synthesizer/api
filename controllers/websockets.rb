# frozen_string_literal: true

module Modusynth
  module Controllers
    # This controller handles the creation of new websocket objects when a user tries to create one.
    # It does not handle sending and receiving messages at it is directly done in the websocket object
    # the user has created to be forwarded to the correct person(s)
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Websockets < Modusynth::Controllers::Base
      api_route 'post', '/' do
        check_request_type!

        request.websocket do |websocket|
          Modusynth::Services::Websockets.instance.create websocket:, session: @session
        end
      end

      def check_request_type!
        unless request.websocket?
          raise Modusynth::Exceptions::BadRequest.new 'request', 'type'
        end
      end
    end
  end
end
