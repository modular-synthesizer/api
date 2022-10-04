RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.clean
  end
  config.after(:suite) do
    DatabaseCleaner.clean
  end
end