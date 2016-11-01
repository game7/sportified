class Host::TenantsController < Host::HostController

  before_filter :mark_return_point, :only => [:edit, :new, :destroy]
  before_filter :find_tenant, :only => [:edit, :update, :destroy]

  def index
    @tenants = Tenant.all
  end

  def edit

  end

  def new
    @tenant = Tenant.new
  end

  def update
    if @tenant.update_attributes(tenant_params)
      return_to_last_point :success => 'Tenant has been updated.'
    else
      flash[:error] = "Tenant could not be updated"
      render :action => "edit"
    end
  end

  def create
    @tenant = Tenant.new(tenant_params)
    if @tenant.save
      return_to_last_point(:notice => 'New Tenant has been created.')
    else
      flash[:error] = "Tenant could not be created"
      render :action => "new"
    end
  end

  def destroy
    @tenant.destroy
    flash[:notice] = "Tenant has been deleted"
  end

  private

  def tenant_params
    params.require(:tenant).permit(:name, :slug, :host, :description, :analytics_id, :theme,
      :twitter_id, :facebook_id, :instagram_id, :foursquare_id, :google_plus_id,
      :stripe_account_id, :stripe_public_api_key)
  end

  def find_tenant
    @tenant = Tenant.find(params[:id])
  end

  def set_breadcrumbs
    super
    add_breadcrumb( "Tenants", host_tenants_path )
  end

end
