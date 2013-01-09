source 'http://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mongoid', '~> 3.0.0'
gem 'bson_ext'
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'mongoid_taggable', :git => 'git://github.com/game7/mongoid_taggable.git'
gem 'haml'
gem 'kaminari'

gem 'devise'
gem 'omniauth'
gem 'oa-oauth', :require => 'omniauth/oauth'

gem 'icalendar'
gem 'chronic'

#gem 'formtastic', '~> 1.2.3'
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git'
#gem 'delayed_job'
gem "less-rails-bootstrap", '>= 2.2.0'
gem 'therubyracer-heroku', '0.8.1.pre3', :group => :production

gem "carrierwave-mongoid", :git => "git://github.com/jnicklas/carrierwave-mongoid.git", :branch => "mongoid-3.0"
gem 'fog'
gem 'rmagick'
gem 'remotipart', '~> 0.4'

#gem "wymeditor-rails", :git => 'git://github.com/game7/wymeditor-rails.git'
gem "RedCloth"


#gem 'pages', :path => "vendor/engines/pages"

# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do

  gem 'rspec', '>= 2.0.1'
  gem 'rspec-rails', '>= 2.0.1'
  gem "remarkable_mongoid", ">= 0.5.0"
  gem 'machinist_mongo', :require => 'machinist/mongoid'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'webrat'
  gem 'capybara'
  gem 'launchy'   # so we can use : Then show me the page
  # Autotest
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-notification'

end

group :development do
  gem 'haml-rails'
  gem 'nifty-generators'  
  gem 'therubyracer', ">= 0.10.1" , :platform => :ruby
end


group :assets do
  gem 'sass-rails', " ~> 3.2.0"
  gem 'coffee-rails', " ~> 3.2.0"
  gem 'uglifier'  
end

gem 'jquery-rails'
