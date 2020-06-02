class Admin::RegistrationsController < Admin::AdminController
  before_action :set_registration, only: [:show, :abandon, :cancel]

  def index
  end

  def show
    add_breadcrumb 'Products', admin_products_path
    add_breadcrumb @registration.product.title, admin_product_path(@registration.product)
    add_breadcrumb 'Registrations', admin_product_registrations_path(@registration.product)
  end

  def abandon
    if @registration.can_abandon?
      @registration.touch(:abandoned_at)
      flash[:success] = 'Registration has been Abandoned'      
    else
      flash[:error] = 'Registration cannot be Abandoned'
    end
    redirect_to [:admin, @registration]
  end

  def cancel
    if @registration.can_cancel?
      @registration.touch(:cancelled_at)
      flash[:success] = 'Registration has been Cancelled'
    else
      flash[:error] = 'Registration cannot be Cancelled'
    end
    redirect_to [:admin, @registration]    
  end

  protected

    def set_breadcrumbs
      super
      add_breadcrumb 'Registration', admin_products_dashboard_path
    end

    def set_registration
      @registration = Registration.includes(:product, :variant).find(params[:id])
    end
end
