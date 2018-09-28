class ChromecastsController < ApplicationController
  skip_before_action :find_current_tenant
  layout 'cast'
  def show
    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
    @chromecast = Chromecast.unscoped.find params[:id]
    Tenant.current = Tenant.find(@chromecast.tenant_id)
    time = Time.parse('9/8/2018 8:00')
    time = Time.zone.now
    @events = Event.where(location: @chromecast.location_id)
                    .ends_after(time)
                    .before(time.at_end_of_day)
                    .order(:starts_on)
  end
end
