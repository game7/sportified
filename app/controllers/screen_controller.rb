class ScreenController < ApplicationController
  skip_before_action :find_current_tenant
  skip_after_action :track_action

  layout 'screen'

  def show
    @device_key = cookies[:device_key] ||= new_device_key
    
    @time = Time.zone.now
    @screen, @events = find_screen_and_events(@device_key, @time)
  
  end

  private

    def new_device_key
      SecureRandom.hex(64)[0,6].upcase
    end

    def find_screen_and_events(device_key, time)
      screen = Screen.unscoped.find_by_device_key(device_key)
      return [nil, nil] unless screen.present?
      
      screen.touch(:refreshed_at)
      Tenant.current = Tenant.find(screen.tenant_id)
      events = Event.where(location: screen.location_id)
                    .ends_after(time)
                    .before(time.at_end_of_day)
                    .order(:starts_on)
      [screen, events]
    end
end
