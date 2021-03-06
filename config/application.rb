require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sportified
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.


    config.generators do |g|
      g.template_engine :haml
      g.orm :active_record
      # g.test_framework :rspec, :fixture => true, :views => false
      # g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/*"]
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += Dir["#{config.root}/app/services/**/*"]
    config.autoload_paths += %W(#{config.root}/app/forms)
    config.autoload_paths += Dir["#{config.root}/app/forms/**/*"]
    config.autoload_paths += %W(#{config.root}/app/validators)
    config.autoload_paths += Dir["#{config.root}/app/validators/**/*"]

    config.to_prepare do
      Dir.glob("#{Rails.root}/app/overrides/**/*_override.rb").each do |override|
        require_dependency override
      end
    end    

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.react.camelize_props = true

  end
end
