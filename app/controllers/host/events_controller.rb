class Host::EventsController < Host::HostController
  def index
    @date = Date.parse(params[:date] || Date.today.to_s)
    @ip = params[:ip].presence

    @events = Ahoy::Event.unscoped.includes(:visit, :user).where('time > ? AND time < ?', @date, @date + 1.day).order(time: :asc)
    @events = @events.joins(:visit).where(ahoy_visits: { ip: @ip }) if @ip.present?
  end
  def show
    @event = Ahoy::Event.unscoped.includes(:visit, :user).find(params[:id])
  end
end
