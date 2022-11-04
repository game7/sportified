class ItemsController < ApplicationController

  def destroy
    @order = Order.find_by_uuid(params[:order_id])
    @registration = Registration.where(order: @order).find(params[:id])
    
    authorize @registration

    @registration.destroy
    redirect_to order_path(@order.uuid), flash: { success: 'Item has been removed from your order' }
  end

end
