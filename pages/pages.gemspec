#require File.expand_path(File.join(*%w[.. .. lib sportified.rb]), __FILE__)
#version = Sportified.version

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'pages'
  s.version     = '0.0.1'
  s.summary     = 'Pages engine for Sportified'
  s.description = 'Ruby on Rails Pages engine for Sportified'
  s.required_ruby_version = '>= 1.8.7'

  s.email       = %q{info@sportified.it}
  s.homepage    = %q{http://sportified.it}
  s.authors     = ['Game 7 Digital Slutions']

  s.files       = Dir['lib/**/*', 'config/**/*', 'app/**/*']
  s.require_path = 'lib'

  #s.add_dependency('refinerycms-base', version)
  #s.add_dependency('refinerycms-core', version)
end
