class ProductsController < ApplicationController

  def index
    @products = Product.active
  end

  def show
    @product = Product.includes(:variants).find(params[:id])
  end

end
