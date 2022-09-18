env = ENV['RACK_ENV'].to_sym || :development

puts "Running on environnement #{env}"

require 'bundler'
Bundler.require(env)

require './module'

Mongoid.load!('config/mongoid.yml', env)

map('/tools') { run Modusynth::Controllers::Tools.new }
map('/parameters') { run Modusynth::Controllers::Parameters.new }
map('/modules') { run Modusynth::Controllers::Modules.new }
map('/synthesizers') { run Modusynth::Controllers::Synthesizers.new }
map('/links') { run Modusynth::Controllers::Links.new }