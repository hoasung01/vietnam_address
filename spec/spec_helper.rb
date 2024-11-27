require 'bundler/setup'
Bundler.setup

require 'vietnam_address'
require 'rspec'
require 'pry'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    VietnamAddress.configure do |config|
      config.reset_configuration!
    end
  end
end
