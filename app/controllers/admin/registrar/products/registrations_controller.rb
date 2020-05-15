class Admin::Registrar::Products::RegistrationsController < Admin::AdminController
  
  def index
    @product = Product.includes(variants: :registrations).find(params[:product_id])
    add_breadcrumb 'Registration', admin_registrar_dashboard_index_path
    add_breadcrumb 'Products', admin_registrar_products_path
  end

end
