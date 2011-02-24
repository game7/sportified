class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :layout

  before_filter :add_stylesheets

  def initialize
    super
    @stylesheets = []
  end

  def find_site
    subdomains = request.subdomains
    subdomains.delete("www")
    Site.with_domain(request.domain).with_subdomain(subdomains.join(".")).first
  end

  def current_site
    @current_site ||= find_site
  end
  helper_method :current_site

  def add_stylesheets
    # http://push.cx/2006/tidy-stylesheets-in-rails
    ["#{controller_path}/shared", "#{controller_path}/#{action_name}"].each do |stylesheet|
      @stylesheets << stylesheet if File.exists? "#{RAILS_ROOT}/public/stylesheets/#{stylesheet}.css"
    end
  end

  def mark_return_point
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def return_to_last_point(response_status = {})
    redirect_to(session[:return_to], response_status)
  end

end
