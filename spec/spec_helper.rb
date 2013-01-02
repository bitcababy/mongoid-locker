begin
  require 'pry'
rescue LoadError
end
require 'rspec'
require 'state_machine'
require 'mongoid'

require File.expand_path '../../lib/mongoid/locker', __FILE__

def database_id
    ENV['CI'] ? "mongoid_locker_#{Process.pid}" : 'mongoid_lock_test'
end

Mongoid.configure do |config|
  config.connect_to database_id
end

Dir['./spec/models/*.rb'].each { |f| require f }

RSpec.configure do |c|
  c.before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end

  c.after(:suite) do
    Mongoid::Threaded.sessions[:default].drop if ENV['CI']
  end
end
