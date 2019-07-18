class Host::EventsController < Host::HostController
  def show
    @event = Ahoy::Event.unscoped.includes(:visit, :user).find(params[:id])
  end
end
