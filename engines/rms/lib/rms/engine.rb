require 'haml'

module Rms
  class Engine < ::Rails::Engine
    isolate_namespace Rms

    #config.assets.paths << File.expand_path("../../assets/javascripts", __FILE__)
    config.assets.precompile += %w( rms/registrations.js )

    config.generators do |g|
      g.template_engine :haml
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
end
