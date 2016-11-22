module Rms
  class ApplicationController < Rms.configuration.base_controller.constantize
    protect_from_forgery with: :exception
    layout 'application'
    before_filter :check_stripe_configuration

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
  end
end
