module Modusynth
  module Controllers
    class Base < Sinatra::Base

      configure do
        set :logger, Logger.new(STDOUT)
        logger.level = Logger::ERROR if ENV['RACK_ENV'] == 'test'
        # This configuration options allow the error handler to work in tests.
        set :show_exceptions, false
        set :raise_errors, false
      end

      def body_params
        request.body.rewind
        JSON.parse(request.body.read.to_s)
      rescue JSON::ParserError
        {}
      end

      error do |errors|
        key = errors.document.errors.messages.keys.first
        message = errors.document.errors.messages[key][0]
        halt 400, {key: key, message: message}.to_json
      end 
    end
  end
end