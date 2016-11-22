require_dependency "rms/application_controller"

module Rms
  class ItemsController < ApplicationController
    before_filter :verify_admin, :except => [:index, :show]
    before_filter :mark_return_point, :only => [:new, :edit]
    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :get_forms, only: [:edit, :update, :new, :create]

    def index
      @items = Item.all
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
        params.required(:item).permit(:title, :description, :form_id, :quantity_allowed,
          variants_attributes: [ :id, :title, :description, :quantity_allowed, :price, :_destroy ])
      end

      def get_forms
        @forms = Form.all
      end
  end
end
