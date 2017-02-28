$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rms"
  s.version     = Rms::VERSION
  s.authors     = ["Chris Woodall"]
  s.email       = ["cmwoodall@game7.net"]
  s.homepage    = "https://github.com/game7/sportified"
  s.summary     = "Sportified Registration Management System (RMS)"
  s.description = "Sportified Registration Management System (RMS)"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0.1"
  s.add_dependency "haml"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "annotate"
end
