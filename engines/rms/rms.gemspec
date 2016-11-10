$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rms"
  s.version     = Rms::VERSION
  s.authors     = ["Chris Woodall"]
  s.email       = ["cmwoodall@game7.net"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rms."
  s.description = "TODO: Description of Rms."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7.1"

  s.add_development_dependency "sqlite3"
end
