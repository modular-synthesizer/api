ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:test)

require './module'

Dir['./spec/support/**/*.rb'].each do |filename|
  require filename
end
Dir['./spec/shared/**/*.rb'].each do |filename|
  require filename
end
Dir['./spec/requests/**/*.rb'].each do |filename|
  require filename
end

Mongoid.load!('config/mongoid.yml', :test)