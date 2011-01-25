class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :layout

  before_filter :add_stylesheets

  def initialize
    super
    @stylesheets = []
  end

  def add_stylesheets
    # http://push.cx/2006/tidy-stylesheets-in-rails
    ["#{controller_path}/shared", "#{controller_path}/#{action_name}"].each do |stylesheet|
      @stylesheets << stylesheet if File.exists? "#{RAILS_ROOT}/public/stylesheets/#{stylesheet}.css"
    end
  end

end
