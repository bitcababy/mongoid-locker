$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mongoid/locker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mongoid-locker"
  s.version     = Mongoid::Locker::VERSION
  s.authors     = ["Meredith Lesly"]
  s.email       = ["meredith@xoala.com"]
  s.homepage    = 'https://github.com/bitcababy/mongoid-locker'
  s.summary     = "Provides simple locking control for objects."
  s.description = "TODO: Description of MongoidLocker."

  s.files       = Dir.glob('lib/**/*') + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']

  s.add_dependency "mongoid", ["~> 3.0"]
  s.add_dependency "activesupport"
  s.add_dependency "state_machine"
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'
end
