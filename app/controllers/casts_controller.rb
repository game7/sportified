class CastsController < ApplicationController
  layout 'cast'

  def index
    @locations = Location.unscoped.includes(:tenant).order(:name)
  end

  def show
    time = Time.now.at_beginning_of_day + 1.days
    original_tenant = Tenant.current
    @location = Location.unscoped.find(params[:slug])
    Tenant.current = @location.tenant
    @events = Event.where(location: @location)
                   .after(time)
                   .before(time.at_end_of_day)
                   .order(:starts_on)
    @posts = Post.tagged_with('cast', :any => true).where("image IS NOT NULL").shuffle
    Tenant.current = original_tenant
  end

end
