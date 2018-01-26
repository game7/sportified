source 'http://rubygems.org'
ruby '2.3.3'
gem 'rails', '~> 5.0.1'

gem 'rms', path: 'engines/rms'

gem 'active_model_serializers', '~> 0.10.2'

gem 'pg'
gem 'enumerize'
gem 'annotate'

gem 'sass-rails', '~> 5.0.4'
#gem 'coffee-rails', '~> 4.0.0.rc1'
gem "sprockets"
gem "sprockets-es6"

gem 'webpacker'


gem 'uglifier', '>=1.3.0'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-sass', '~> 4.7.0'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'autoprefixer-rails'

gem 'react-rails'

gem 'tenancy'
gem 'ancestry'
gem 'acts-as-taggable-on', '~> 4.0'

gem 'haml'
gem 'kaminari'

gem 'devise', '~>4.2.0'
gem 'omniauth'
# gem 'oa-oauth', :require => 'omniauth/oauth'

gem 'icalendar', '~> 2.3.0'
gem 'chronic'

gem 'simple_form', '~> 3.4.0'
gem 'virtus', '~> 1.0.5'

gem 'cocoon'
#gem 'delayed_job'

gem 'carrierwave'
gem 'fog-aws', group: [:staging, :production]
gem 'rmagick', '~> 2.13.4'
gem 'remotipart', '~> 1.3.1'

gem 'haml-rails'

gem "simple_calendar", "~> 2.0"

gem 'invoicing', '~> 1.0.1'
gem 'stripe'

gem "RedCloth"
gem 'redcarpet', '~> 3.4.0'

gem 'unicorn'

gem "exception_logger", :github => "ryancheung/exception_logger"

source 'https://rails-assets.org' do
  gem 'rails-assets-moment'
end



#gem 'pages', :path => "vendor/engines/pages"

# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do
  gem 'rspec', '>= 3.5'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'webrat'
  # gem 'capybara'
  gem 'launchy'   # so we can use : Then show me the page
  gem 'autotest'
  gem 'autotest-rails'
  gem 'rspec-autotest'
  gem 'autotest-notification'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem "spring"
  gem 'byebug'
  gem 'foreman'
end

gem 'jquery-rails'

gem 'rails_12factor', group: [:staging, :production]
