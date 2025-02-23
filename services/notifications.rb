# frozen_string_literal: true

module Modusynth
  module Services
    class Notifications
      include Singleton

      attr_reader :channel, :connection

      def initialize
        return if ENV['RACK_ENV'] == 'test'

        @connection = Bunny.new ENV.fetch('RMQ_URI', nil)
        @connection.start
        @channel = connection.create_channel
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

      def send(prefix, operation, session, payload)
        return if @connection.nil? || session.expired?

        queue_name = "#{ENV.fetch('RACK_ENV', 'development')}.#{prefix}"

        exchange = channel.topic(queue_name, durable: true, auto_delete: true)
        body = { operation: operation, payload: JSON.parse(payload) }.to_json
        exchange.publish(body, routing_key: session.token)
      end
    end
  end
end
