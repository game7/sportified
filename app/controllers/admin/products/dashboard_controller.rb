class Admin::Products::DashboardController < Admin::AdminController
  skip_before_action :verify_admin
  before_action :verify_admin_or_operations

  def index
    products = Product.active.includes(:registrable).order(updated_at: :desc).limit(10)

    product_registrations = Registration.joins(:product)
                                        .where('products.id IN (?)', products.select(:id))
                                        .group('products.id')

    render locals: {
      products: products,
      registrations: Registration.order(id: :desc).limit(10),
      from_date: from_date,
      statistics: {
        pending: product_registrations.pending.count,
        completed: product_registrations.completed.count,
        abandoned: product_registrations.abandoned.count,
        cancelled: product_registrations.pending.count,
        revenue: product_registrations.completed.sum(:price)
      }
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
