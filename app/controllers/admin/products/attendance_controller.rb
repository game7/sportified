class Admin::Products::AttendanceController < Admin::AdminController
  def index
    @product = Product.find(params[:product_id])
  end

end
