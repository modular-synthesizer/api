# frozen_string_literal: true

module Modusynth
  module Services
    module Notifications
      class Notifier
        attr_reader :channel, :tab_id

        def initialize(tab_id = 'unknown')
          @tab_id = tab_id
          @channel = connection.create_channel unless connection.nil?
        end

        def connection
          Modusynth::Services::Notifications::Connection.instance.get
        end

        # Sends a notification payload to several users' sessions that could want to be notified.
        # These sessions do not need to be connected as the TTL for these command messages are very short.
        #
        # @param sessions [Array<Modusynth::Models::Session>] the sessions to send the notification to.
        # @param payload [string] a JSON representation of the payload object we want to send the user.
        def command(operation, sessions, payload)
          sessions.each do |session|
            publish('commands', operation, session.token, payload) unless session.expired?
          end
        end

        private

        def exchange(prefix)
          channel.topic("#{ENV.fetch('RACK_ENV', 'development')}.#{prefix}")
        end

        def publish(prefix, operation, routing_key, payload)
          return if channel.nil?

          payload = JSON.parse(payload).merge(tab_id.nil? ? {} : { tab_id: })
          exchange(prefix).publish({ operation:, payload: }.to_json, routing_key:)
        end
      end
    end
  end
end
