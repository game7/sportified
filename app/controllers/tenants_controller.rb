class TenantsController < ApplicationController
  layout 'layouts/tenantless'

  def index
    @tenants = Tenant.all
  end

  def select
    @tenant = Tenant.find( params[:id])
    session[:tenant_id] = @tenant.id
    redirect_to root_path
  end

end
