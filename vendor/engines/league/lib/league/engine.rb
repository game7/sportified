require 'league'
require 'rails'

module League
  class Engine < Rails::Engine
    
    config.autoload_paths += %W( #{config.root}/lib/ )
    config.autoload_paths += Dir["#{config.root}/lib/**/*"]

  end
end
