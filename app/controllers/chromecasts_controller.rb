class ChromecastsController < ApplicationController
  skip_before_action :find_current_tenant
  layout 'cast'
  def show
    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
    @chromecast = Chromecast.unscoped.find params[:id]
    @chromecast.update_columns(refreshed_at: Time.current)
    Tenant.current = Tenant.find(@chromecast.tenant_id)
    @events = Event.where(location: @chromecast.location_id)
                    .ends_after(Time.zone.now)
                    .before(Time.zone.now.at_end_of_day)
                    .order(:starts_on)
  end
end
