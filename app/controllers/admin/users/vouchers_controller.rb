class Admin::Users::VouchersController < Admin::AdminController
  before_action :set_user, only: [:index, :create]

  def index

  end

  def create
    @voucher = @user.vouchers.build voucher_params
    if @voucher.valid?
      (@voucher.quantity - 1).times do
        @user.vouchers.build voucher_params
      end
      @user.save
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def voucher_params
    params.require(:voucher).permit(:amount, :quantity, :expires_at)
  end

end
