require 'dotenv'
require 'mongoid'
require './module'

ENV.merge!(Dotenv.load)
Mongoid.load!('./config/mongoid.yml', ENV['RACK_ENV'] || :development)