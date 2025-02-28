# frozen_string_literal: true

module Modusynth
  module Services
    module Notifications
      class Notifier

        attr_reader :channel, :tab_id

        def initialize(tab_id = '')
          @channel = connection.create_channel
          @tab_id = tab_id
        end

        # Sends a notification payload to several users' sessions that could want to be notified.
        # These sessions do not need to be connected as the TTL for these command messages are very short.
        #
        # @param sessions [Array<Modusynth::Models::Session>] the sessions to send the notification to.
        # @param payload [string] a JSON representation of the payload object we want to send the user.
        def command(operation, sessions, payload)
          sessions.each do |session|
            send('commands', operation, session, payload)
          end
        end

        def connection
          Modusynth::Services::Notifications::Connection.instance
        end

        def send(prefix, operation, session, payload)
          return if @channel.nil? || session.expired?

          queue = "#{ENV.fetch('RACK_ENV', 'development')}.#{prefix}"
          exchange = channel.topic(queue)
          payload = payload.merge({ tab_id: @tab_id })
          body = { operation: operation, payload: JSON.parse(payload) }.to_json
          exchange.publish(body, routing_key: session.token)
        end
      end
    end
  end
end
