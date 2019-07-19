class ApplicationController < ActionController::Base
  rescue_from StandardError, :with => :track_exception unless Rails.env.development?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, unless: :devise_controller?

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  helper :layout

  prepend_before_action :find_current_tenant
  around_action :with_time_zone
  before_action :add_stylesheets
  before_action :load_objects
  before_action :set_breadcrumbs
  before_action :set_area_navigation
  after_action :track_action

  def initialize
    super
    @stylesheets = []
    @breadcrumbs = []
  end

  protected

  @@RAILS_ROOT_REGEX = /^#{Regexp.escape(Rails.root.to_s)}/

  def filter_backtrace(backtrace)
    backtrace.collect{|line| Pathname.new(line.gsub(@@RAILS_ROOT_REGEX, "[RAILS_ROOT]")).cleanpath.to_s}
  end

  def track_exception(exception)
    ahoy.track 'exception', {
      host: request.host,
      path: request.fullpath,
      url: request.url,
      format: request.format.to_s,
      params: request.filtered_parameters,
      exception: exception.class.name,
      message: exception.message.inspect,      
      # env: request.filtered_env,
      backtrace: filter_backtrace(exception.backtrace)
    }
    track_action
    raise exception
  end

  def track_action
    ahoy.track 'controller:action', {
      host: request.host,
      path: request.fullpath,
      url: request.url,
      format: request.format.to_s,
      params: request.filtered_parameters
    }
  end

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
  alias_method :breadcrumb, :add_breadcrumb
  helper_method :breadcrumb

  def add_area_menu_item(title, url = nil)
    @area_menu_items ||= []
    @area_menu_items << { :title => title, :url => url }
  end

  def url_current?(url)
    url.present? && ( url == request.path || url == request.url )
  end

  def find_current_tenant
    if Rails.env.production?
      if request.subdomain == 'www'
        ::Tenant.current = ::Tenant.find_by!(host: request.domain.downcase)
      else
        ::Tenant.current = ::Tenant.find_by!(slug: request.subdomain.downcase)
      end
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

  def with_time_zone
    Time.use_zone('Arizona') { yield }
  end

end
