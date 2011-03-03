class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :layout

  before_filter :set_current_site
  before_filter :add_stylesheets

  def initialize
    super
    @stylesheets = []
  end

  def set_current_site
    Site.current ||= find_site
  end

  def find_site
    #subdomains = request.subdomains
    #subdomains.delete("www")
    Site.for_host(request.host).first
  end

  def add_stylesheets
    # http://push.cx/2006/tidy-stylesheets-in-rails
    ["#{controller_path}/shared", "#{controller_path}/#{action_name}"].each do |stylesheet|
      #TODO - dirty hack added below -- need more reliable file path
      @stylesheets << stylesheet if File.exists? "#{RAILS_ROOT}/vendor/engines/core/public/stylesheets/#{stylesheet}.css"
    end
  end

  def mark_return_point
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def return_to_last_point(response_status = {})
    redirect_to(session[:return_to], response_status)
  end

end
