require 'bundler'
Bundler.require(:test)

require './module'

Dir['./spec/support/**/*.rb'].each do |filename|
  require filename
end

Mongoid.load!('config/mongoid.yml', :test)