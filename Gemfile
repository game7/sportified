source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'sqlite3-ruby', :require => 'sqlite3'
#gem 'mongoid', '2.0.0.beta.20'
#gem 'bson_ext', '1.1.5'
gem 'mongoid', :git => 'https://github.com/mongoid/mongoid.git'
gem 'bson_ext', '1.2'
#gem 'mongoid_slug', :require => 'mongoid/slug'
gem 'haml'
gem 'devise'
gem 'formtastic', '~> 1.1.0'
gem 'delayed_job'
gem 'compass', ">= 0.10.6"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
 gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do

  gem 'rspec', '>= 2.0.1'
  gem 'rspec-rails', '>= 2.0.1'
  gem "remarkable_mongoid", ">= 0.5.0"
  gem 'machinist_mongo', :require => 'machinist/mongoid'
  gem 'faker'
  gem 'webrat'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'capybara'
  gem 'launchy'   # so we can use : Then show me the page
  gem 'factory_girl_rails'
  # Autotest
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-notification'

end

group :development do
  gem 'nifty-generators'  
end
