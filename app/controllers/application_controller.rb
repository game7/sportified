class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  protect_from_forgery
  helper :layout

  before_filter :set_current_site
  before_filter :add_stylesheets
  before_filter :load_objects
  before_filter :set_site_navigation
  before_filter :set_breadcrumbs
  before_filter :set_area_navigation
  
  before_filter do |c|
    puts c.class.to_s
  end



  def initialize
    super
    @stylesheets = []
    @breadcrumbs = []
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def load_objects
    
  end

  def set_breadcrumbs
    @breadcrumbs ||= []
  end

  def set_site_navigation
    @site_menu_items ||= []
    pages = Page.for_site(Site.current).top_level.in_menu.live.asc(:position)
    pages.each do |page|
      @site_menu_items << { :title => page.title, :url => get_page_url(page) }    
    end
  end

  def get_page_url(page)
    url = page.link_url unless page.link_url.blank?
    url ||= page_friendly_path(page.path)
  end
  helper_method :get_page_url

  def set_area_navigation
    
  end

  def add_breadcrumb(title, url = nil)
    @breadcrumbs ||= []
    @breadcrumbs << { :title => title, :url => url }
  end

  def add_area_menu_item(title, url = nil)
    @area_menu_items ||= []
    @area_menu_items << { :title => title, :url => url }
  end

  def add_area_ancestor(title, url = nil, selected = nil)
    @area_ancestors ||= []
    selected ||= url_current?(url)
    @area_ancestors << { :title => title, :url => url, :selected => selected }
  end

  def add_area_descendant(title, url = nil, selected = nil)
    @area_descendants ||= []
    selected ||= url_current?(url)
    @area_descendants << { :title => title, :url => url, :selected => selected }
  end

  def url_current?(url)
    url.present? && ( url == request.path || url == request.url )
  end


  def set_current_site
    Site.current = find_site
  end

  def find_site
    Site.for_host( request.host.gsub("www.","") ).first
  end

  def add_stylesheets
    # http://push.cx/2006/tidy-stylesheets-in-rails
    ["compiled/#{controller_path}/shared", "compiled/#{controller_path}/#{action_name}"].each do |stylesheet|
      @stylesheets << stylesheet if File.exists? "#{::Rails.root.to_s}/tmp/stylesheets/#{stylesheet}.css"
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
