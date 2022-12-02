class Host::DashboardController < Host::BaseController
  def index
    inertia props: {}
  end

  def status; end
end
