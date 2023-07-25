module Modusynth
  module Services
    # A channel links a session to its corresponding websocket in the registry of websockets. It allows the
    # forwarding of messages to the session via the corresponding websocket.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Channel
      # @!attribute [r] session
      #   @return [Modusynth::Models::Session] the session the user has identified on.
      attr_reader :session
      # @!attribute [r] websocket
      #   @return [SinatraWebsocket::Connection] the websocket connection to the frontend for this session
      attr_reader :websocket

      def initialize session: nil, websocket: nil
        @session = session
        @websocket = websocket

        websocket.onmessage do |message|
          Modusynth::Services::Websockets::Create.instance.forward message:, sender: self
        end
      end

      def send message: nil

      end

      def token
        session.token
      end
    end
  end
end