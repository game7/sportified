class Admin::Products::DashboardController < Admin::AdminController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations

  def index
    products = Product.active.includes(
      :registrable,
      pending_registrations: [], 
      completed_registrations: [],
      abandoned_registrations: [],
      cancelled_registrations: []).order(updated_at: :desc).limit(10)
    registrations = Registration.order(id: :desc).limit(10)
    render locals: {
      products: products,
      registrations: registrations,
      from_date: from_date
    }
  end

  private

    def from_date
      case params[:period]
      when 'month'
        Date.today.at_beginning_of_month
      when 'week'
        Date.today.at_beginning_of_week
      when 'day'
        Date.today
      else
        Date.parse('2000-01-01')
      end
    end

  protected

    def set_breadcrumbs
      super
      add_breadcrumb 'Registration', admin_products_dashboard_path
    end    

end
