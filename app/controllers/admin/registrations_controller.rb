class Admin::RegistrationsController < Admin::AdminController
  skip_before_action :verify_admin, only: [:index, :show, :toggle_check_in]
  before_action :verify_admin_or_operations, only: [:index, :show]  
  before_action :set_registration, only: [:show, :abandon, :cancel, :toggle_check_in]

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

  def toggle_check_in
    if @registration.checked_in_at.blank?
      @registration.touch(:checked_in_at)
    else
      @registration.update_attribute(:checked_in_at, nil)
    end
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
