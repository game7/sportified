class ApplicationController < ActionController::Base
  include ExceptionLogger::ExceptionLoggable
  rescue_from StandardError, :with => :log_exception_handler unless Rails.env.development?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, unless: :devise_controller?

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  helper :layout

  before_action :find_current_tenant
  before_action :add_stylesheets
  before_action :load_objects
  before_action :set_breadcrumbs
  before_action :set_area_navigation

  def initialize
    super
    @stylesheets = []
    @breadcrumbs = []
  end

  protected

  def json_request?
    puts "format: #{request.format}"
    request.format.json?
  end

  def redirect_https
    if Rails.env.production?
      secure_url = "https://#{Tenant.current.slug}.sportified.net#{request.fullpath}"
      redirect_to secure_url unless request.ssl?
    end
    return true
  end

  def set_time_zone(&block)
    Time.use_zone(Tenant.current.time_zone, &block)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:first_name, :last_name]
    devise_parameter_sanitizer.permit :account_update, keys: [:first_name, :last_name]
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end

  def load_objects

  end

  def set_breadcrumbs
    @breadcrumbs ||= []
  end

  def get_page_url(page)
    if page.skip_to_first_child and child = page.children.order(:position).first
      url = get_page_url(child)
    end
    url ||= page.link_url unless page.link_url.blank?
    url ||= main_app.page_friendly_path(page.url_path)
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
    if Rails.env.production?
      slug = request.subdomain.downcase
      ::Tenant.current = ::Tenant.find_by!('host = ? OR slug = ?', request.domain, slug)
    else
      if session[:tenant_id]
        ::Tenant.current = ::Tenant.find(session[:tenant_id])
      else
        redirect_to tenants_path unless controller_name == 'tenants'
      end
    end
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
    current_user and current_user.host?
  end
  helper_method :current_user_is_host?

  def current_user_is_admin?
    current_user_is_host? || has_admin_role?(current_user, Tenant.current.id)
  end
  helper_method :current_user_is_admin?

  def verify_admin
    unless current_user_is_admin?
      if current_user
        render :file => "public/401.html", :status => :unauthorized, :layout => false
      else
        redirect_to main_app.new_user_session_path
      end
    end
  end

  def has_admin_role?(user, tenant_id)
    user and user.admin?(tenant_id)
  end

  def verify_user
    redirect_to main_app.new_user_session_path unless current_user
  end

end
