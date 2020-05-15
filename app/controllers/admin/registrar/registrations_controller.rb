class Admin::Registrar::RegistrationsController < Admin::AdminController
  def index
  end

  def show
    @registration = Registration.includes(:product, :variant).find(params[:id])
    add_breadcrumb 'Products', admin_registrar_products_path
    add_breadcrumb @registration.product.title, admin_registrar_product_path(@registration.product)
    add_breadcrumb 'Registrations', admin_registrar_product_registrations_path(@registration.product)
  end

  protected

    def set_breadcrumbs
      super
      add_breadcrumb 'Registration', admin_registrar_dashboard_index_path
    end
end
