class ApplicationController < ActionController::Base

  protect_from_forgery
  helper :layout

  before_filter :find_current_tenant
  before_filter :add_stylesheets
  before_filter :load_objects
  before_filter :set_site_navigation
  before_filter :set_breadcrumbs
  before_filter :set_area_navigation

  def initialize
    super
    @stylesheets = []
    @breadcrumbs = []
  end
  
  private

  def load_objects
    
  end

  def set_breadcrumbs
    @breadcrumbs ||= []
  end

  def set_site_navigation
    @site_menu_items ||= []
    pages = Page.roots.in_menu.live.order(:position)
    pages.each do |page|
      @site_menu_items << page    
    end
  end

  def get_page_url(page)
    if page.skip_to_first_child and child = page.children.order(:position).first
      url = get_page_url(child)
    end
    url ||= page.link_url unless page.link_url.blank?
    url ||= page_friendly_path(page.url_path)
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

  def url_current?(url)
    url.present? && ( url == request.path || url == request.url )
  end

  def find_current_tenant
    # find current tenant by either full hostname or subdomain
    host = request.host.gsub("www.","").downcase
    slug = request.host.split(".").first.downcase
    Tenant.current = Tenant.where("host = ? OR slug = ?", host, slug).first
    # raise routing exception if tenant not found
    raise ActionController::RoutingError.new("Not Found") unless Tenant.current
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
    session[:return_to] = params[:return_to] || request.env["HTTP_REFERER"]
  end
  
  def return_url
    session[:return_to]
  end
  helper_method :return_url

  def return_to_last_point(response_status = {})
    response_status = {:flash => response_status} unless response_status[:flash]
    redirect_to(session[:return_to], response_status)
  end

  
  def current_user_is_host?
    current_user and current_user.role? :super_admin
  end
  helper_method :current_user_is_host?
  
  def current_user_is_admin?
    current_user_is_host? || has_admin_role?(current_user, Tenant.current.id)
  end
  helper_method :current_user_is_admin?
  
  def verify_admin
    redirect_to root_url unless current_user_is_admin?
  end 
  
  def has_admin_role?(user, tenant_id)
    result = false
    user.roles.find_by_name(:admin).each do |role|
      result = true if role.tenant_id == tenant_id
    end if user
    result
  end

end
