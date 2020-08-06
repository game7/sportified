class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers
  rescue_from StandardError, :with => :track_exception unless Rails.env.development?

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  skip_before_action :verify_authenticity_token, if: :json_request?

  helper :layout

  prepend_before_action :find_current_tenant
  around_action :with_time_zone
  before_action :add_stylesheets
  before_action :load_objects
  before_action :set_breadcrumbs
  before_action :set_area_navigation
  before_action :set_mailer_host
  skip_before_action :track_ahoy_visit
  after_action :track_action

  def initialize
    super
    @stylesheets = []
    @breadcrumbs = []
  end

  protected

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

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
    request.format.json?
  end

  def redirect_https
    if Rails.env.production?
      secure_url = "https://#{Tenant.current.slug}.sportified.net#{request.fullpath}"
      redirect_to secure_url unless request.ssl?
    end
    if Rails.env.preview? && request.protocol != 'https://'
      redirect_to protocol: 'https://'
    end
  end

  def set_time_zone(&block)
    Time.use_zone(Tenant.current.time_zone, &block)
  end

  def load_objects

  end

  def set_breadcrumbs
    @breadcrumbs ||= []
  end

  def get_page_url(page)
    page.link_url.presence || main_app.page_friendly_path(page.url_path)
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

  def add_area_menu_item(title, url = nil, klass = nil)
    @area_menu_items ||= []
    @area_menu_items << { title: title, url: url, class: klass }
  end

  def url_current?(url)
    url.present? && ( url == request.path || url == request.url )
  end

  def find_current_tenant
    if ::Tenant.current.present?
      Rails.logger.debug 'Tenant present'
      return
    end
    if Rails.env.production?
      if request.subdomain == 'www'
        Rails.logger.debug 'Determining Tenant from custom domain'
        ::Tenant.current = ::Tenant.find_by!(host: request.domain.downcase)
      else
        Rails.logger.debug 'Determining Tenant from subdomain'
        ::Tenant.current = ::Tenant.find_by!(slug: request.subdomain.downcase)
      end
    else
      return set_tenant_from_passwordless_session if params[:authenticatable] && params[:token]      
      return set_tenant_from_session if session[:tenant_id]
      Rails.logger.debug 'Unable to determine Tenant -- Redirecting to Tenant Picker'
      redirect_to tenants_path unless controller_name == 'tenants'
    end
  end

  def set_tenant_from_session
    Rails.logger.debug 'Restoring Tenant from session'
    ::Tenant.current = ::Tenant.find(session[:tenant_id])
  end

  def set_tenant_from_passwordless_session
    Rails.logger.debug 'Setting Tenant from Passwordless session'
    session_model = ::Passwordless::Session.unscoped.find_by_token(params[:token])
    session[:tenant_id] = session_model.tenant_id   
    ::Tenant.current = ::Tenant.find(session_model.tenant_id)
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
    redirect_to(params[:return_to] || session[:return_to], response_status)
  end

  helper_method :current_user

  def current_user
    return if session[session_key(User)].blank?
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    return if current_user
    save_passwordless_redirect_location!(User)
    redirect_to root_path, flash: { error: 'You are not worthy!' }
  end  

  def current_user_is_host?
    current_user && current_user.host?
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
        redirect_to users.sign_in_path
      end
    end
  end

  def has_admin_role?(user, tenant_id)
    user && user.admin?(tenant_id)
  end

  def verify_user
    redirect_to users.sign_in_path unless current_user
  end

  def with_time_zone
    Time.use_zone('Arizona') { yield }
  end

end
