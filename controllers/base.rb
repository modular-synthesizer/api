module Modusynth
  module Controllers
    class Base < Sinatra::Base
      register Sinatra::CrossOrigin
      
      before do
        content_type :json    
        headers({
          'Access-Control-Allow-Origin' => '*', 
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT', 'PATCH', 'DELETE']
        })
      end

      configure do
        enable :cross_origin
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

      error Mongoid::Errors::Validations do |error|
        raise Modusynth::Esceptions.from_validation error
      end

      error Modusynth::Exceptions::BadRequest do |exception|
        halt 400, {key: exception.key, message: exception.error}.to_json
      end

      error Modusynth::Exceptions::Unknown do |exception|
        halt 404, {key: exception.key, message: exception.error}.to_json
      end
      
      options "*" do
        200
      end
    end
  end
end