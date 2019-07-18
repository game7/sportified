class TenantsController < ApplicationController
  layout 'layouts/tenantless'
  skip_before_action :track_ahoy_visit
  skip_after_action :track_action

  def index
    @tenants = Tenant.all
  end

  def select
    @tenant = Tenant.find( params[:id])
    session[:tenant_id] = @tenant.id
    redirect_to root_path
  end

end
