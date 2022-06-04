source 'http://rubygems.org'
ruby '2.7.6'
gem 'rails', '~> 6.1.0'

gem 'active_model_serializers', '~> 0.10.2'

gem 'enumerize'
gem 'pg'

gem 'sprockets'

gem 'webpacker', '~> 4'

gem 'paranoia', '~> 2.3'

gem 'uglifier', '>=1.3.0'

gem 'react-rails'

gem 'acts-as-taggable-on'
gem 'ancestry'
gem 'tenancy'

# visit & event tracking
gem 'ahoy_matey'
gem 'chartkick'
gem 'groupdate'

gem 'haml'
gem 'kaminari'

gem 'passwordless'

gem 'chronic'
gem 'icalendar', '~> 2.3.0'

gem 'audited', '~> 4.6'
gem 'simple_form'
gem 'view_component', require: 'view_component/engine'
gem 'virtus', '~> 1.0.5'

gem 'cocoon'
# gem 'delayed_job'

gem 'carrierwave'
gem 'carrierwave-base64'
gem 'fog-aws', group: %i[staging production]
gem 'rmagick', '>= 2.13.4'

# active_storage deps
gem 'aws-sdk-s3', require: false
gem 'image_processing', '~> 1.2'

gem 'haml-rails'

gem 'simple_calendar', '~> 2.0'

gem 'stripe'

gem 'redcarpet', '~> 3.4.0'
gem 'RedCloth'

gem 'ice_cube', '~> 0.16.2'

gem 'jquery-rails'

gem 'rails_12factor', group: %i[staging production]

gem 'tailwindcss-rails'

# gem 'pages', :path => 'vendor/engines/pages'

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
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'derailed_benchmarks'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'guard-rspec', require: false

  gem 'annotate'

  gem 'rack-mini-profiler'

  gem 'foreman'

  gem 'htmlbeautifier'
  gem 'rails-erd', '~> 1.6'
  gem 'rubocop', '~> 1.25'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'

  gem 'rails-controller-testing'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers'
end

group :production do
  gem 'puma', '>= 4.3.5'
end
