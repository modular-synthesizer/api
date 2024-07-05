ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:test)

require './constants/rights'
require './module'

['spec/request', 'spec/shared', 'spec/support'].each do |folder|
  Dir["./#{folder}/**/*.rb"].each { |fn| require fn }
end

Mongoid.load!('config/mongoid.yml', :test)