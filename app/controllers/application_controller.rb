class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  protect_from_forgery
  helper :layout

  before_filter :set_current_site
  before_filter :add_stylesheets

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def initialize
    super
    @stylesheets = []
  end

  def set_current_site
    Site.current = find_site
  end

  def find_site
    #subdomains = request.subdomains
    #subdomains.delete("www")
    Site.for_host(request.host).first
  end

  def add_stylesheets
    # http://push.cx/2006/tidy-stylesheets-in-rails
    ["compiled/#{controller_path}/shared", "compiled/#{controller_path}/#{action_name}"].each do |stylesheet|
      @stylesheets << stylesheet if File.exists? "#{RAILS_ROOT}/tmp/stylesheets/#{stylesheet}.css"
    end
  end

  def stylesheets
    @stylesheets
  end

  def mark_return_point
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def return_to_last_point(response_status = {})
    redirect_to(session[:return_to], response_status)
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, Site.current ? Site.current.id : nil)
  end

end
