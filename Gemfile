source 'http://rubygems.org'
ruby '3.0.5'
gem 'rails', '~> 7.0'

gem 'active_model_serializers', '~> 0.10.2'

gem 'pg'

gem 'enumerize'

gem 'sass-rails', '~> 5.0.4'
gem 'sprockets'

gem 'vite_rails'

gem 'inertia_rails', '>= 1.2.2'

gem 'paranoia'


gem 'uglifier', '>=1.3.0'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'autoprefixer-rails'

gem 'react-rails'

gem 'tenancy'
gem 'ancestry'
gem 'acts-as-taggable-on'

# visit & event tracking
gem 'ahoy_matey'
gem 'maxminddb'
gem 'geolite2_city'
gem 'chartkick'
gem 'groupdate'

gem 'haml'
gem 'kaminari'

gem 'passwordless'

gem 'icalendar', '~> 2.3.0'
gem 'chronic'

gem "view_component", require: "view_component/engine"
gem 'simple_form'
gem 'virtus', '~> 1.0.5'
gem 'audited'

gem 'cocoon'
#gem 'delayed_job'

gem 'carrierwave'
gem 'carrierwave-base64'
gem 'fog-aws', group: [:staging, :production]
gem 'rmagick', '>= 2.13.4'

# active_storage deps
gem "aws-sdk-s3", require: false
gem 'image_processing', '~> 1.2'

gem 'haml-rails'

gem 'simple_calendar', '~> 2.0'

gem 'stripe'

gem 'RedCloth'
gem 'redcarpet', '~> 3.4.0'

gem 'ice_cube', '~> 0.16.2'

gem 'jquery-rails'

gem 'rails_12factor', group: [:staging, :production]

#gem 'pages', :path => 'vendor/engines/pages'

# gem 'aws-s3', :require => 'aws/s3'

# # Bundle gems for the local environment. Make sure to
# # put test-only gems in this group so their generators
# # and rake tasks are available in development mode:
# group :test do
#   gem 'rspec', '>= 3.5'
#   gem 'rspec-rails', '~> 3.5'
#   gem 'factory_girl_rails'
#   gem 'faker'
#   gem 'webrat'
#   # gem 'capybara'
#   gem 'launchy'   # so we can use : Then show me the page
#   gem 'autotest'
#   gem 'autotest-rails'
#   gem 'rspec-autotest'
#   gem 'autotest-notification'
#   gem 'database_cleaner'
#   gem 'shoulda-matchers', '~> 3.1'
# end

# group :development do
#   gem 'spring'
#   gem 'byebug'
#   gem 'foreman'
#   gem 'thin'
#   gem 'listen', '~> 3.0'
# end

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5'
  
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'derailed_benchmarks'

  gem 'guard-rspec', require: false  
 
  gem 'annotate'

  gem 'rubocop-rails', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'

  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

group :production do
  gem 'puma', ">= 4.3.5"
end
