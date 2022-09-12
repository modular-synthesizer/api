source 'https://rubygems.org/'

group :development, :production, :test do
  gem 'mongoid', '8.0.2'
  gem 'mongoid-embedded-errors', '4.0.0'
  gem 'sinatra', '2.2.2'
  gem 'draper', '4.0.2'
end

group :development, :production do
  gem 'puma', '5.6.5'
end

group :development, :test do
  gem 'pry', '0.14.1'
end

group :test do
  gem 'database_cleaner-mongoid', '2.0.1'
  gem 'rack-test', '2.0.2', require: 'rack/test'
  gem 'rspec', '3.11.0'
  gem 'rspec-json_expectations', '2.2.0'
end