class ScreenController < ApplicationController
  skip_before_action :find_current_tenant
  # skip_after_action :track_action

  layout 'screen'

  def show
    @device_key = cookies[:device_key] ||= new_device_key

    @time = Time.zone.now
    @screen, @events = find_screen_and_events(@device_key, @time)
  end

  private

  def new_device_key
    SecureRandom.hex(64)[0, 6].upcase
  end

  def find_screen_and_events(device_key, time)
    screen = Screen.unscoped.find_by(device_key: device_key)
    return [nil, nil] if screen.blank?

    screen.touch(:refreshed_at) # rubocop:disable Rails/SkipsModelValidations
    Tenant.current = Tenant.find(screen.tenant_id)
    events = Event.includes(:location)
                  .where(location: screen.location_ids)
                  .ends_after(time)
                  .before(time.at_end_of_day)
                  .order(:starts_on)
    [screen, events]
  end
end
