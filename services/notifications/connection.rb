# frozen_string_literal: true

module Modusynth
  module Services
    module Notifications
      # This class is just a simple wrapped singleton to get only one connection object to the RMQ.
      # This connection SHOULD NOT be used directly, but instead be derived as a channel before use.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Connection
        include Singleton

        # @!attribute [rw] get
        #   @return [Connection] A Bunny connection to the RMQ broker.
        attr_reader :get

        def initialize
          return if ENV['RACK_ENV'] == 'test'

          @get = Bunny.new ENV.fetch('RMQ_URI', nil)
          @get.start
        end
      end
    end
  end
end
