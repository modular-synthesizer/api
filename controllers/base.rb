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
        JSON.parse(request.body.read.to_s).merge(params)
      rescue JSON::ParserError
        params
      end

      # We find the authentication session here and NOT in the ownership service as we sometimes
      # need to make authentication controls without ownership check.
      #
      # @return [Modusynth::Models::Session] the aauthentication session linked to the provided
      #   :auth_token parameter value.
      #
      # @raise [Modusynth::Exceptions::BadRequest] when the :auth_token field is NOT provided
      # @raise [Modusynth::Exceptions::Unknown] when the :auth_token does not reference any of
      #   the sessions persisted in the database.
      def auth_session
        raise Modusynth::Exceptions.required 'auth_token' unless body_params.key? 'auth_token'
        result = Modusynth::Models::Session.where(token: body_params['auth_token']).first
        raise Modusynth::Exceptions.unknown 'auth_token' if result.nil?
        raise Modusynth::Exceptions.forbidden 'auth_token' if result.expired?
        result
      end

      error Mongoid::Errors::Validations do |error|
        exception = Modusynth::Exceptions.from_validation error
        halt 400, {key: exception.key, message: exception.error}.to_json
      end

      error Modusynth::Exceptions::BadRequest do |exception|
        halt 400, {key: exception.key, message: exception.error}.to_json
      end

      error Modusynth::Exceptions::Unknown do |exception|
        halt 404, {key: exception.key, message: exception.error}.to_json
      end

      error Modusynth::Exceptions::Forbidden do |exception|
        halt 403, {key: exception.key, message: exception.error}.to_json
      end
      
      options "*" do
        200
      end
    end
  end
end