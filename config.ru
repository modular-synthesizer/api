env = ENV['RACK_ENV'].to_sym || :development

require 'bundler'
Bundler.require(env)

require './module'

Mongoid.load!('config/mongoid.yml', env)

map('/tools') { run Modusynth::Controllers::Tools.new }