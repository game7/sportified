# Adapted from
# http://github.com/chriseppstein/compass/issues/issue/130
# and other posts.
#
# another useful post: https://gist.github.com/585051

# Create the dir
require 'fileutils'
FileUtils.mkdir_p(Rails.root.join("tmp", "stylesheets"))

Sass::Plugin.on_updating_stylesheet do |template, css|
  puts "Compiling #{template} to #{css}"
end

# watch local engines
Rails::Application.railties.engines.each do |engine|
  if engine.config.root.to_s.starts_with?(Rails.root)
    Sass::Plugin.add_template_location(engine.config.root + "app/stylesheets", Rails.root + 'tmp/stylesheets/compiled')
  end
end

Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static',
                                             :urls => ['/stylesheets'],
                                             :root => "#{Rails.root}/tmp")

