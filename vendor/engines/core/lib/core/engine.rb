require 'core'
require 'rails'

module Sportified
  module Core
    class Engine < Rails::Engine
      config.autoload_paths += %W( #{config.root}/lib )

      initializer "static assets" do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
    end
  end
end
