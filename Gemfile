source 'https://rubygems.org/'

group :development, :production, :test do
  gem 'bcrypt', '3.1.18'
  gem 'mongoid', '8.0.2'
  gem 'mongoid-embedded-errors', '4.0.0'
  gem 'sinatra', '2.2.2'
  gem 'draper', '4.0.2'
  gem 'sinatra-cross_origin', '0.4.0', require: 'sinatra/cross_origin'
end

group :development, :production do
  gem 'puma', '5.6.5'
end

group :development, :test do
  gem 'pry', '0.14.1'
end

group :test do
  gem 'database_cleaner-mongoid', '2.0.1'
  gem 'factory_bot', '6.2.1'
  gem 'rack-test', '2.0.2', require: 'rack/test'
  gem 'rspec', '3.11.0'
  gem 'rspec_junit_formatter', '0.6.0'
  gem 'rspec-json_expectations', '2.2.0'
  gem 'rubocop', '1.36.0'
end