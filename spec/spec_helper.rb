require 'bundler'
Bundler.require(:test)

Dir['./spec/support/**/*.rb'].each do |filename|
  require filename
end

require './module'

Mongoid.load!('config/mongoid.yml', :test)