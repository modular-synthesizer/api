# frozen_string_literal: true

module Modusynth
  module Controllers
    class Base < Sinatra::Base
      register Sinatra::CrossOrigin
      register Modusynth::Helpers::Routes
      helpers Modusynth::Helpers::Payloads

      attr_accessor :notifier, :tab_id

      before do
        content_type :json
        headers({
                  'Access-Control-Allow-Origin' => '*',
                  'Access-Control-Allow-Methods' => '*'
                })
        @tab_id = symbolized_params[:tab_id] || 'unknown'
        @notifier = Modusynth::Services::Notifications::Notifier.new(@tab_id)
      end

      configure do
        enable :cross_origin
        set :logger, Logger.new($stdout)
        logger.level = Logger::ERROR if ENV['RACK_ENV'] == 'test'
        # This configuration options allow the error handler to work in tests.
        set :show_exceptions, false
        set :raise_errors, false
        set :views, proc { File.join(root, '..', 'views') }
      end

      error Mongoid::Errors::Validations do |error|
        exception = Modusynth::Exceptions.from_validation error
        halt 400, { key: exception.key, message: exception.error }.to_json
      end

      error Modusynth::Exceptions::Validation do |error|
        exception = Modusynth::Exceptions.from_validation error
        halt 400, { key: exception.key, message: exception.error }.to_json
      end

      error Modusynth::Exceptions::BadRequest do |exception|
        halt 400, { key: exception.key, message: exception.error }.to_json
      end

      error Modusynth::Exceptions::Unknown do |exception|
        halt 404, { key: exception.key, message: exception.error }.to_json
      end

      error Modusynth::Exceptions::Forbidden do |exception|
        halt 403, { key: exception.key, message: exception.error }.to_json
      end

      error Modusynth::Exceptions::Service do |exception|
        halt exception.status, exception.message
      end

      error StandardError do |exception|
        halt 500, { message: exception.message }.to_json
      end

      options '*' do
        200
      end

      def render_json(filename, status: 200, **locals)
        halt status, jbuilder(filename.to_sym, locals:)
      end

      def t
        symbolized_params[:t] || DateTime.now
      end

      attr_reader :session
    end
  end
end
