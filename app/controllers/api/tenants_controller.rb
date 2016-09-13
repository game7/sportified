class Api::TenantsController < Api::BaseController

  def index
    render json: ::Tenant.all
  end

end
