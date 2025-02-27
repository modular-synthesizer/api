module Modusynth
  module Services
    module Notifications
      class connection
        include Singleton

        attr_reader :connection
  
        def initialize
          return if ENV['RACK_ENV'] == 'test'

          @connection = Bunny.new ENV.fetch('RMQ_URI', nil)
          @connection.start
        end
      end
    end
  end
end