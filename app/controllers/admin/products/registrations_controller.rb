require 'csv'

class Admin::Products::RegistrationsController < Admin::AdminController
  include ActiveSupport::NumberHelper
  skip_before_action :verify_admin, only: [:index, :show]
  before_action :verify_admin_or_operations, only: [:index, :show]  
  
  def index
    respond_to do |format|
      format.html do
        @product = Product.includes(variants: :registrations).find(params[:product_id])
        add_breadcrumb 'Registration', admin_products_dashboard_path
        add_breadcrumb 'Products', admin_products_path
      end
      format.csv do
        registrations = Registration.joins(:variant)
                                    .where(variants: { product_id: params[:product_id] })
                                    .includes(variant: [ :product ], forms: [ :template ])     
        send_data to_csv(registrations), filename: "product-#{params[:product_id]}-registrations.csv"
      end
    end    

  end

  private

    # def extract
    #   registrations = Registration.joins(:variant)
    #                               .where(variants: { product_id: params[:product_id] })
    #                               .includes(variant: [ :item ], forms: [])

    #   columns = %w( street city state postal )

    #   data = registrations.collect do |r|
    #     result = {
    #       id: r.id,
    #       email: r.email,
    #       participant_name: r.last_name_first_name,
    #       status: r.status
    #     }
    #     data = r.forms[0].data || {}
    #     columns.each do |col|
    #       field = "home_address-#{col}"
    #       result[col.to_sym] = data[field]
    #     end
    #     result            
    #   end
    # end

    def sanitize(str)
      str.strip                 # strip spaces
         .gsub(/\R+/, ' ')      # remvoe newlines
         .gsub(/^\"|\"$/, '')   # remove outer quotes
         .gsub(/\"\"/, '"')     # fix double quotes
    end    

    def to_csv(registrations)
      results = registrations.map do |r|
        result = {
          id: r.id,
          date: r.created_at.strftime("%a %-m/%-d/%y %l:%M %P"),
          email: r.email,
          first_name: r.first_name,
          last_name: r.last_name,
          birthdate: r.birthdate.strftime('%-m/%-d/%y'),
          product: r.variant.product.title,
          variant: r.variant.title,
          price: number_to_currency(r.price, :unit => "$").presence || 'Free',
          status: r.status
        }
        r.forms.each do |form|
          form.data&.each do |key, value|
            result[form.template.name.underscore + '-' + key] = sanitize(value)
          end
        end
        result
      end

      ::CSV.generate do |csv|
        csv << results[0].keys
        results.each{|row| csv << row.values }
      end
    end  

end
