class Admin::Registrar::DashboardController < Admin::AdminController
  
  def index
    products = Product.all.order(:title)
    render locals: {
      products: products,
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
      add_breadcrumb 'Registration', admin_registrar_dashboard_index_path
    end    

end
