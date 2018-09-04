class CastsController < ApplicationController
  layout 'cast'

  def index
    @locations = Location.unscoped.includes(:tenant).order(:name)
  end

  def show
    puts request.user_agent
    @location = Location.unscoped.find(params[:slug])
    original_tenant = Tenant.current
    Tenant.current = @location.tenant
    time = Time.zone.now
    @events = Event.where(location: @location)
                   .ends_after(time)
                   .before(time.at_end_of_day)
                   .order(:starts_on)
                   .limit(4)
    @posts = Post.tagged_with('cast', :any => true).where("image IS NOT NULL").shuffle
    Tenant.current = original_tenant
  end

end
