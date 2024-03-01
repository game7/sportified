# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  registrable_id     :integer
#  registrable_type   :string
#  title              :string(40)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  tenant_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active             :boolean
#  summary            :text
#  private            :boolean
#  roster             :boolean
#
# Indexes
#
#  index_products_on_registrable_type_and_registrable_id  (registrable_type,registrable_id)
#  index_products_on_tenant_id                            (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

class ProductsController < ApplicationController
  def index
    @products = Product.active.where(private: [nil, false]).order(id: :desc)
    @products = @products.where('title ILIKE ?', "%#{params[:q]}%") if params[:q].present?
  end

  def show
    @product = Product.includes(:variants).where(id: params[:id], private: [nil, false])
                      .or(Product.where(private_token: params[:id]))
                      .sole
  end
end
