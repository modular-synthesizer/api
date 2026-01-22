RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.clean
    FactoryBot.create(:full_rights)
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
