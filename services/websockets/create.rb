# frozen_string_literal: true

module Modusynth
  module Services
    module Websockets
      # This services aims at creating websockets, and forward messages to the correct users. Messages are forwarded
      # depending on their type :
      # - Synthesizers-wide messages are forwarded to every person able to access the synthesizer if they are logged in
      # - Conversation-wide messages are forwarded to every person in the conversation logged in.
      # Messages are also forwarded to the sender himself
      class Create
        include Singleton

        attr_reader :channels

        def initialize
          @channels = 
        end

        # Creates a websocket for the given session. The granularity is the session to allow several sessions of the same
        # user to communicate between one another so that changes are reflected between several devices.
        # @param session [Modusynth::Models::Session] the session to link the websocket to.
        def create session: nil, websocket: nil
          channels[session.token] = Channel.new(session:, websocket:, registry: self)
        end

        def forward message: nil, sender: nil
          message = Messages::Create.instance.create message:

          
          puts "Forwarding message from #{sender.token} of type #{message.type}"
        end
      end
    end
  end
end
