Sportified::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  
  Mongoid.logger.level = Logger::DEBUG
  Moped.logger.level = Logger::DEBUG  

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false
  
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.default_url_options = { :host => 'localhost' }  
  config.action_mailer.delivery_method = :file
  config.action_mailer.file_settings = { :location => Rails.root.join('tmp/mail') }
  config.action_mailer.default :charset => "utf-8"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true  
end

