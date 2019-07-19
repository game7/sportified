# == Schema Information
#
# Table name: rms_items
#
#  id                 :integer          not null, primary key
#  parent_id          :integer
#  parent_type        :string
#  title              :string(40)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  tenant_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active             :boolean
#
# Indexes
#
#  index_rms_items_on_parent_type_and_parent_id  (parent_type,parent_id)
#  index_rms_items_on_tenant_id                  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

require_dependency "rms/application_controller"

module Rms
  class ItemsController < ApplicationController
    before_action :verify_admin, :except => [:index, :show]
    before_action :mark_return_point, :only => [:new, :edit]
    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :get_form_packets, only: [:edit, :update, :new, :create]

    def index
      @items = ::Rms::Item.all
      @items = @items.active unless current_user_is_admin?
      @stripe_url = stripe_url
    end

    def show
    end

    def new
      @item = Item.new
    end

    def edit
    end

    def create
      @item = Item.new(item_params)

      if @item.save
        redirect_to @item, notice: 'Item was successfully created.'
      else
        puts @item.errors.messages
        flash[:error] = "Item could not be created"
        render :new
      end
    end

    def update
      if @item.update(item_params)
        redirect_to @item, notice: 'Item was successfully updated.'
      else
        flash[:error] = "Item could not be created"
        render :edit
      end
    end

    def destroy
      @item.destroy
      redirect_to items_url, notice: 'Item was successfully destroyed.'
    end

    private

      def set_item
        @item = Item.includes(:variants).find(params[:id])
      end

      def item_params
        params.required(:item).permit(:title, :description, :quantity_allowed, :active,
          variants_attributes: [ :id, :title, :description, :form_packet_id, :quantity_allowed, :price, :_destroy ])
      end

      def get_form_packets
        @form_packets = FormPacket.all
      end
  end
end
