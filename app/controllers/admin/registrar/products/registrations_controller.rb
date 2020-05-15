require 'csv'

class Admin::Registrar::Products::RegistrationsController < Admin::AdminController
  include ActiveSupport::NumberHelper
  
  def index
    respond_to do |format|
      format.html do
        @product = Product.includes(variants: :registrations).find(params[:product_id])
        add_breadcrumb 'Registration', admin_registrar_dashboard_index_path
        add_breadcrumb 'Products', admin_registrar_products_path
      end
      format.csv do
        @product = Product.includes(variants: :registrations).find(params[:product_id])
        send_data to_csv(@product.registrations), filename: "product-#{params[:product_id]}-registrations.csv"
      end
    end    

  end

  private

    def to_csv(registrations)
      data = registrations.map do |r|
        {
          date: r.created_at.strftime("%a %-m/%-d/%y %l:%M %P"),
          name: r.full_name,
          summary: r.birthdate,
          product: r.product.title,
          variant: r.variant.title,
          price: number_to_currency(r.price, :unit => "$").presence || 'Free'
        }
      end
      ::CSV.generate do |csv|
        csv << data[0].keys
        data.each{|row| csv << row.values }
      end
    end  

end
