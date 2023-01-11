# frozen_string_literal: true

module Modusynth
  module Controllers
    class Base < Sinatra::Base
      register Sinatra::CrossOrigin
      register Modusynth::Helpers::Routes
      helpers Modusynth::Helpers::Payloads

      before do
        content_type :json
        headers({
                  'Access-Control-Allow-Origin' => '*',
                  'Access-Control-Allow-Methods' => '*'
                })
      end

      configure do
        enable :cross_origin
        set :logger, Logger.new($stdout)
        logger.level = Logger::ERROR if ENV['RACK_ENV'] == 'test'
        # This configuration options allow the error handler to work in tests.
        set :show_exceptions, false
        set :raise_errors, false
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
    end
  end
end
