require 'dotenv'
ENV.merge!(Dotenv.load)

env = ENV['RACK_ENV'].to_sym || :development

puts "Running on environnement #{env}"

require 'bundler'
Bundler.require(env)

require './module'
Mongoid.load!('config/mongoid.yml', env)

Modusynth::Services::Initialization.instance.run

map('/accounts') { run Modusynth::Controllers::Accounts.new }
map('/applications') { run Modusynth::Controllers::Applications.new }
map('/categories') { run Modusynth::Controllers::Categories.new }
map('/generators') { run Modusynth::Controllers::Generators.new }
map('/groups') { run Modusynth::Controllers::Groups.new }
map('/links') { run Modusynth::Controllers::Links.new }
map('/memberships') { run Modusynth::Controllers::Memberships.new }
map('/modules') { run Modusynth::Controllers::Modules.new }
map('/rights') { run Modusynth::Controllers::Rights.new }
map('/sessions') { run Modusynth::Controllers::Sessions.new }
map('/synthesizers') { run Modusynth::Controllers::Synthesizers.new }
map('/tools') { run Modusynth::Controllers::Tools.new }

map('/tools/controls') { run Modusynth::Controllers::ToolsResources::Controls.new }
map('/tools/links') { run Modusynth::Controllers::ToolsResources::InnerLinks.new }
map('/tools/nodes') { run Modusynth::Controllers::ToolsResources::InnerNodes.new }
map('/tools/parameters') { run Modusynth::Controllers::ToolsResources::Parameters.new }
map('/tools/ports') { run Modusynth::Controllers::ToolsResources::Ports.new }