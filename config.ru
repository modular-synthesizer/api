require 'dotenv'
ENV.merge!(Dotenv.load)

env = ENV['RACK_ENV'].to_sym || :development

puts "Running on environnement #{env}"

require 'bundler'
Bundler.require(env)

require './constants/index'
require './module'
Mongoid.load!('config/mongoid.yml', env)
Mongo::Logger.level = ENV.fetch('MONGO_LOGGING_LEVEL', 1).to_i

Modusynth::Services::Initialization.instance.run

map('/accounts') { run Modusynth::Controllers::Accounts.new }
map('/categories') { run Modusynth::Controllers::Categories.new }
map('/experiments/base') { run Modusynth::Controllers::Bare.new }
map('/generators') { run Modusynth::Controllers::Generators.new }
map('/groups') { run Modusynth::Controllers::Groups.new }
map('/links') { run Modusynth::Controllers::Links.new }
map('/memberships') { run Modusynth::Controllers::Memberships.new }
map('/modules') { run Modusynth::Controllers::Modules.new }
map('/parameters') { run Modusynth::Controllers::Parameters.new }
map('/rights') { run Modusynth::Controllers::Rights.new }
map('/sessions') { run Modusynth::Controllers::Sessions.new }
map('/synthesizers') { run Modusynth::Controllers::Synthesizers.new }
map('/blueprints') { run Modusynth::Controllers::Blueprints::Blueprints.new }

map('/blueprints/links') { run Modusynth::Controllers::Blueprints::InnerLinks.new }
map('/blueprints/nodes') { run Modusynth::Controllers::Blueprints::InnerNodes.new }
map('/blueprints/:blueprint_id/controls') { run Modusynth::Controllers::Blueprints::Controls.new }
map('/blueprints/:blueprint_id/parameters') { run Modusynth::Controllers::Blueprints::Parameters.new }
map('/blueprints/:blueprint_id/ports') { run Modusynth::Controllers::Blueprints::Ports.new }
