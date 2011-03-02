# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
# serve static assets from tmp folder -- http://mentalized.net/journal/2010/04/06/heroku_rails_3_and_sass/
use Rack::Static, :urls => ["/vendor/engines/core/public/stylesheets/compiled"], :root => "tmp"
run Sportified::Application
