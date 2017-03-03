module Rms
  class ApplicationController < Rms.configuration.base_controller.constantize
    protect_from_forgery with: :exception
    layout 'application'
    before_filter :check_stripe_configuration
    before_filter :set_area_navigation

    protected

    def stripe_url
      protocol = request.host == 'localhost' ? 'http://' : 'https://'
      host = request.host
      host = "#{host}:#{request.port}" if host == 'localhost'
      "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV['STRIPE_CLIENT_ID']}&scope=read_write&redirect_uri=#{protocol}#{host}"
    end

    def check_stripe_configuration
      display_stripe_instructions if Tenant.current.stripe_account_id.blank?
    end

    def display_stripe_instructions
      flash[:notice] = "Stripe payments have not been configured."\
                       "  In order to receive payments you must first "\
                       " <a href=\"#{stripe_url}\">connect to stripe</a>."
    end

    def set_area_navigation
      super
      if current_user_is_admin?
        add_area_menu_item 'Home'   , items_path
        add_area_menu_item 'Dashboard' , dashboard_path
        add_area_menu_item 'Forms', form_templates_path
      end
    end

  end
end
