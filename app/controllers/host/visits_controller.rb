class Host::VisitsController < Host::HostController
  def index
    @date = Date.parse(params[:date]) if params[:date]
    @ip = params[:ip] if params[:ip]
    
    @visits = Ahoy::Visit.unscoped.all
    
    @visits = @visits.where(ip: @ip) if @ip
    @visits = @visits.where(os: params[:device]) if params[:device]
    @visits = @visits.where(os: params[:os]) if params[:os]
    @visits = @visits.where(browser: params[:browser]) if params[:browser]
    @visits = @visits.where(tenant_id: params[:tenant_id]) if params[:tenant_id]
    
    @by_device = @visits.group(:device_type).order(Arel.sql('COUNT(*) DESC')).count
    @by_os = @visits.group(:os).order(Arel.sql('COUNT(*) DESC')).count
    @by_browser = @visits.group(:browser).order(Arel.sql('COUNT(*) DESC')).count
    @by_all = @visits.group(:device_type, :os, :browser).order(Arel.sql('COUNT(*) DESC')).count
    
    @by_day = @visits.group_by_day(:started_at).count

    @visits = @visits.where(started_at: [@date...(@date + 1.days)]).order(started_at: :asc) if @date
  end

  def show
    @visit = Ahoy::Visit.unscoped.includes(:user).find(params[:id])
  end
end
