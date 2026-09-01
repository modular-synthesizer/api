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

puts "Checking after initialization"

map('/accounts') { run Modusynth::Controllers::Accounts.new }
map('/categories') { run Modusynth::Controllers::Categories.new }
map('/experiments/base') { run Modusynth::Controllers::Bare.new }
map('/experiments') { run Modusynth::Controllers::Experiments.new }
map('/generators') { run Modusynth::Controllers::Generators.new }
map('/groups') { run Modusynth::Controllers::Groups.new }
map('/links') { run Modusynth::Controllers::Links.new }
map('/memberships') { run Modusynth::Controllers::Memberships.new }
map('/modules') { run Modusynth::Controllers::Modules.new }
map('/parameters') { run Modusynth::Controllers::Parameters.new }
map('/rights') { run Modusynth::Controllers::Rights.new }
map('/sessions') { run Modusynth::Controllers::Sessions.new }
map('/synthesizers') { run Modusynth::Controllers::Synthesizers.new }
map('/blueprints') { run Modusynth::Controllers::Blueprints.new }

map('/blueprints/controls') { run Modusynth::Controllers::ToolsResources::Controls.new }
map('/blueprints/links') { run Modusynth::Controllers::ToolsResources::InnerLinks.new }
map('/blueprints/nodes') { run Modusynth::Controllers::ToolsResources::InnerNodes.new }
map('/blueprints/parameters') { run Modusynth::Controllers::ToolsResources::Parameters.new }
map('/blueprints/ports') { run Modusynth::Controllers::ToolsResources::Ports.new }


puts "Checking after routes"