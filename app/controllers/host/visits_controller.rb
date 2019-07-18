class Host::VisitsController < Host::HostController
  def index
    @visits = Ahoy::Visit.unscoped.all
    @by_device = @visits.group(:device_type).count
    @by_os = @visits.group(:os).count
    @by_browser = @visits.group(:browser).count
    @visits = @visits.order(started_at: :desc).page(params[:page])
  end

  def show
    @visit = Ahoy::Visit.unscoped.includes(:user).find(params[:id])
  end
end
