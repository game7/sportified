class Admin::RegistrationsController < Admin::AdminController
  def index
  end

  def show
    @registration = Registration.includes(:product, :variant).find(params[:id])
    add_breadcrumb 'Products', admin_products_path
    add_breadcrumb @registration.product.title, admin_product_path(@registration.product)
    add_breadcrumb 'Registrations', admin_product_registrations_path(@registration.product)
  end

  protected

    def set_breadcrumbs
      super
      add_breadcrumb 'Registration', admin_products_dashboard_path
    end
end
