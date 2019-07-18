class Host::EventsController < Host::HostController
  def show
    @event = Ahoy::Event.includes(:visit, :user).find(params[:id])
  end
end
