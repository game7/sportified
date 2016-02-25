source 'http://rubygems.org'
ruby '2.2.0'
gem 'rails', '~> 4.2'

gem 'active_model_serializers'

gem 'pg'
gem 'hstore_accessor', '~> 0.9.0'
gem 'enumerize'
gem 'annotate'

gem 'sass-rails', '~> 5.0.4'
#gem 'coffee-rails', '~> 4.0.0.rc1'
gem "sprockets"
gem "sprockets-es6"

gem 'uglifier', '>=1.3.0'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-sass', '~> 4.3.0'
gem 'autoprefixer-rails'

gem 'ember-rails'
gem 'ember-source', '~> 2.3.1'
gem 'ember-cli-rails'

gem 'tenancy'
gem 'ancestry'
gem 'acts_as_taggable_on'

gem 'mongoid', '~> 4.0.1'
#gem 'bson_ext'
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'mongoid_taggable', :git => 'git://github.com/game7/mongoid_taggable.git'
gem 'haml'
gem 'kaminari'

gem 'devise'
gem 'omniauth'
gem 'oa-oauth', :require => 'omniauth/oauth'

gem 'icalendar', '~> 2.3.0'
gem 'chronic'

gem 'simple_form', '~> 3.1.0.rc2'
#gem 'delayed_job'


gem 'carrierwave'
gem 'fog'
gem 'rmagick', '~> 2.13.4'
gem 'remotipart', '~> 1.0'

gem "RedCloth"

gem 'unicorn'

source 'https://rails-assets.org' do
  gem 'rails-assets-moment'
end


#gem 'pages', :path => "vendor/engines/pages"

# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do

  gem 'rspec', '>= 2.0.1'
  gem 'rspec-rails', '~> 3.1.0'
  gem "remarkable_mongoid", ">= 0.5.0"
  gem 'machinist_mongo', :require => 'machinist/mongoid'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'webrat'
  gem 'capybara'
  gem 'launchy'   # so we can use : Then show me the page
  gem 'autotest'
  gem 'autotest-rails'
  gem 'rspec-autotest'
  gem 'autotest-notification'
  gem 'database_cleaner'
end

group :development do
  gem 'haml-rails'
  gem 'nifty-generators'
end

gem 'jquery-rails'

gem 'rails_12factor', group: [:staging, :production]
