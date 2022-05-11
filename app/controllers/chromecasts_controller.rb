# == Schema Information
#
# Table name: chromecasts
#
#  id                 :integer          not null, primary key
#  name               :string
#  tenant_id          :integer
#  location_id        :integer
#  playing_surface_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  refreshed_at       :datetime
#
# Indexes
#
#  index_chromecasts_on_location_id         (location_id)
#  index_chromecasts_on_playing_surface_id  (playing_surface_id)
#  index_chromecasts_on_tenant_id           (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (playing_surface_id => facilities.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

class ChromecastsController < ApplicationController
  skip_before_action :find_current_tenant
  layout 'cast'
  def show
    response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
    @chromecast = Chromecast.unscoped.find params[:id]
    @chromecast.update_columns(refreshed_at: Time.current)
    Tenant.current = Tenant.find(@chromecast.tenant_id)
    @time = Time.zone.now - 1.days
    @events = Event.where(location: @chromecast.location_id)
                    .ends_after(@time)
                    .before(@time.at_end_of_day)
                    .order(:starts_on)
  end
end
