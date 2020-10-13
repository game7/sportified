class Admin::Products::AttendanceController < Admin::AdminController
  skip_before_action :verify_admin, only: [:index]
  before_action :verify_admin_or_operations, only: [:index]  

  def index
    @product = Product.find(params[:product_id])
  end

end
