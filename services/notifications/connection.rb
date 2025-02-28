module Modusynth
  module Services
    module Notifications
      class Connection
        include Singleton

        attr_reader :connection
  
        def initialize
          return if ENV['RACK_ENV'] == 'test'

          @connection = Bunny.new ENV.fetch('RMQ_URI', nil)
          @connection.start
        end

        def create_channel
          return if ENV['RACK_ENV'] == 'test'

          connection.create_channel
        end
      end
    end
  end
end